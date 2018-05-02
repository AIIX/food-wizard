import re
import sys
import subprocess
import json
import requests
import unidecode
import dbus
from adapt.intent import IntentBuilder
from os.path import join, dirname
from string import Template
from mycroft.skills.core import MycroftSkill, intent_handler
from mycroft.skills.context import *
from mycroft.util import read_stripped_lines
from mycroft.util.log import getLogger
from mycroft.messagebus.message import Message

__author__ = 'Aix'

LOGGER = getLogger(__name__)

class FoodWizardSkill(MycroftSkill):
    def __init__(self):
        super(FoodWizardSkill, self).__init__(name="FoodWizardSkill")
        self.app_id = self.settings['app_id']
        self.app_key = self.settings['app_key']

    @intent_handler(IntentBuilder("RecipeByKeys").require("RecipeKeyword").build())
    def handle_search_recipe_by_keys_intent(self, message):
        utterance = message.data.get('utterance').lower()
        utterance = utterance.replace(message.data.get('RecipeKeyword'), '')
        searchString = utterance.encode('utf-8')
        
        method = "GET"
        url = "https://api.edamam.com/search"
        cat = re.split('\s+', searchString)
        if 'and' in cat:
            index = cat.index('and')
            del cat[index]
        cat = ','.join([x for x in cat if x])
        data = "?q={0}&app_id={1}&app_key={2}&count=5".format(cat, self.app_id, self.app_key)
        response = requests.request(method,url+data)
        global globalObject
        globalObject = response.json()
        resultCount = len(globalObject['hits'])
        resultSpeak = "Found {0} recipe's".format(resultCount)
        self.speak(resultSpeak)
        self.enclosure.ws.emit(Message("recipesObject", {'desktop': {'data': response.text}}))
        
    @intent_handler(IntentBuilder("ReadRecipeMethod").require("ReadRecipeKeyword").build())  
    def handle_read_recipe_method_intent(self, message):
        utterance = message.data.get('utterance').lower()
        utterance = utterance.replace(message.data.get('ReadRecipeKeyword'), '')
        foodTitle = utterance.encode('utf-8').lstrip(' ')

        for recipes in globalObject['hits']:
            rtitlelist = recipes['recipe']['label']
            rfilteredtlist = rtitlelist.lower()
            decodeString = unidecode.unidecode(rfilteredtlist)
            rfilteredtlistnospecial = re.sub('\W+',' ', decodeString)
            if foodTitle in rfilteredtlistnospecial:
                    getRecipeMethod = recipes['recipe']['ingredientLines']
                    ingredients = json.dumps(getRecipeMethod)
                    self.speak(ingredients)
                    bus = dbus.SessionBus()
                    remote_object = bus.get_object("org.kde.mycroftapplet", "/mycroftapplet")
                    remote_object.showRecipeMethod(foodTitle, dbus_interface="org.kde.mycroftapplet")
    
    def stop(self):
        pass
    
def create_skill():
    return FoodWizardSkill()
