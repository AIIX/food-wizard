"""
FoodWizard Mycroft Skill.
"""
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

__author__ = 'aix'

LOGGER = getLogger(__name__)


class FoodWizardSkill(MycroftSkill):
    def __init__(self):
        """
        FoodWizard Skill Class.
        """    
        super(FoodWizardSkill, self).__init__(name="FoodWizardSkill")
        self.app_id = self.settings['app_id']
        self.app_key = self.settings['app_key']
    
    def initialize(self):
    # Initialize...
        self.gui.register_handler('foodwizard.showrecipe', self.handle_show_recipes)

    @intent_handler(IntentBuilder("RecipeByKeys").require("RecipeKeyword").build())
    def handle_search_recipe_by_keys_intent(self, message):
        """
        Search Recipes By Keywords
        """    
        utterance = message.data.get('utterance').lower()
        utterance = utterance.replace(message.data.get('RecipeKeyword'), '')
        searchString = utterance
        
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
        resultSpeak = "Found {0} recipes".format(resultCount)
        self.gui["recipeBlob"] = globalObject
        self.gui.show_page("SearchRecipe.qml")
        self.speak(resultSpeak)
                
    @intent_handler(IntentBuilder("ReadRecipeMethod").require("ReadRecipeKeyword").build())
    def handle_read_recipe_method_intent(self, message):
        """
        Read Recipes By Keywords
        """
        utterance = message.data.get('utterance').lower()
        utterance = utterance.replace(message.data.get('ReadRecipeKeyword'), '')
        foodTitle = utterance.replace(" ", "").lower()
        self.speak(foodTitle)
        for x in globalObject['hits']:
            mapLabel = x['recipe']['label'].replace("-", "").replace(" ", "").lower()
            if mapLabel == foodTitle:
                recipeTitle = x['recipe']['label']
                recipeHealthTag = x['recipe']['healthLabels']
                recipeHealthTagArray = {"healthTags": recipeHealthTag}
                recipeCalories = x['recipe']['calories']
                recipeImage = x['recipe']['image']
                recipeDietType = x['recipe']['dietLabels']
                recipeDietTypeArray = {"dietTags": recipeDietType}
                recipeIngredients = x['recipe']['ingredientLines']
                recipeIngredientArray = {"ingredients": recipeIngredients}
                recipeSource = x['recipe']['source']
                self.gui["recipeTitle"] = recipeTitle
                self.gui["recipeHealthTag"] = recipeHealthTagArray
                self.gui["recipeCalories"] = recipeCalories
                self.gui["recipeImage"] = recipeImage
                self.gui["recipeDietType"] = recipeDietTypeArray
                self.gui["recipeIngredients"] = recipeIngredientArray
                self.gui["recipeSource"] = recipeSource
                self.gui.show_page("RecipeDetail.qml")
                
    def handle_show_recipes(self, message):
        """
        Show Recipes By Keywords
        """
        foodTitle = message.data["recipe"].lower()
        self.speak(foodTitle)
        for x in globalObject['hits']:
            mapLabel = x['recipe']['label'].replace("-", "").replace(" ", "").lower()
            if mapLabel == foodTitle:
                recipeTitle = x['recipe']['label']
                recipeHealthTag = x['recipe']['healthLabels']
                recipeHealthTagArray = {"healthTags": recipeHealthTag}
                recipeCalories = x['recipe']['calories']
                recipeImage = x['recipe']['image']
                recipeDietType = x['recipe']['dietLabels']
                recipeDietTypeArray = {"dietTags": recipeDietType}
                recipeIngredients = x['recipe']['ingredientLines']
                recipeIngredientArray = {"ingredients": recipeIngredients}
                recipeSource = x['recipe']['source']
                self.gui["recipeTitle"] = recipeTitle
                self.gui["recipeHealthTag"] = recipeHealthTagArray
                self.gui["recipeCalories"] = recipeCalories
                self.gui["recipeImage"] = recipeImage
                self.gui["recipeDietType"] = recipeDietTypeArray
                self.gui["recipeIngredients"] = recipeIngredientArray
                self.gui["recipeSource"] = recipeSource
                self.gui.show_page("RecipeDetail.qml")
                
    @intent_handler(IntentBuilder("RecipesSlideShow").require("RecipesSlideshowKeyword").build())
    def handle_experimental_slideshow_mode(self, message):
        """
        Show Recipes As SlideShow
        """
        self.gui["recipeBlob"] = globalObject
        self.gui.show_page("SliderRecipes.qml")

    def stop(self):
        """
        Mycroft Stop Function
        """
        pass
    
def create_skill():
    """
    Mycroft Create Skill Function
    """
    return FoodWizardSkill()
