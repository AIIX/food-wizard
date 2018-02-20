import re
import sys
import subprocess
import json
import requests
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
    @adds_context('GetRecipeContext')
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
        
    def stop(self):
        pass
    
def create_skill():
    return FoodWizardSkill()
