#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# Copyright (c) 2016 - 2022 by Aditya Mehra <Aix.m@outlook.com>
# All rights reserved.

import re
import requests

from mycroft.skills.core import MycroftSkill, intent_file_handler
from mycroft.skills.context import *
from mycroft_bus_client.message import Message
from .skill import providerHelper

__author__ = 'aix'


class FoodWizardSkill(MycroftSkill):
    def __init__(self):
        """
        FoodWizard Skill Class.
        """
        super(FoodWizardSkill, self).__init__(name="FoodWizardSkill")
        self.app_id = None
        self.app_key = None
        self.recipes_object = None
        self.provider_helper = None
        self.active_recipe = None

    def initialize(self):
        """ 
        Mycroft Initialize Function
        """
        self.provider_helper = providerHelper.ProviderHelper()
        self.app_id = self.settings.get('app_id', '')
        self.app_key = self.settings.get('app_key', '')
        self.gui.register_handler('foodwizard.showrecipe',
                                  self.handle_show_recipes)
        self.add_event('food-wizard.aiix.home', self.showHome)
        self.gui.register_handler('foodwizard.searchrecipe',
                                  self.handle_search_recipe_by_ui)
        self.gui.register_handler('foodwizard.readrecipe.ingredients',
                                  self.handle_read_current_recipe_ingredients_intent)
        self.gui.register_handler('foodwizard.readrecipe.instructions',
                                  self.handle_read_current_recipe_instructions_intent)

    @intent_file_handler("open.food.wizard.intent")
    def showHome(self, message):
        """
        Show A Homescreen
        
        Args:
            message: Mycroft Message
        """       
        self.gui.show_page("FoodWizardHome.qml")

    @intent_file_handler("go.back.to.recipes.selection.intent")
    def handle_go_back_to_recipes_selection_intent(self, message):
        """
        Go Back To Recipes Selection
        
        Args:
            message: Mycroft Message
        """
        if not self.recipes_object:
            return

        self.gui.show_page("SearchRecipe.qml", override_idle=True)
        
    def handle_search_recipe_by_ui(self, message):
        """ 
        Search Recipe From Home
        
        Args:
            message: Mycroft Message
        """
        query = message.data.get("query", "")
        if query:
            searchString = query
            self.handle_search_query(searchString)
        else:
            return

    @intent_file_handler('search.recipe.intent')
    def handle_search_recipe_by_voice(self, message):
        """
        Search Recipes By Keywords
        
        Args:
            message: Mycroft Message
        """
        utterance = message.data.get('ingredients', '')
        self.log.info(f"Searching for recipes with ingredients: {utterance}")
        if utterance:
            searchString = utterance
            self.handle_search_query(searchString)
        else:
            return
    
    def handle_search_query(self, searchString):
        cat = re.split('\s+', searchString)
        if 'and' in cat:
            index = cat.index('and')
            del cat[index]
        cat = ','.join([x for x in cat if x])
        results = None
        
        if self.app_id and self.app_key:
            results = self.use_direct_api(cat)
        else:
            results = self.use_ovos_api(cat)

        if results:
            self.gui.show_page("FoodWizardHome.qml")
            self.recipes_object = results
            resultCount = len(self.recipes_object['hits'])
            self.gui["recipeBlob"] = self.recipes_object
            for x in self.recipes_object['hits']:
                print(x['recipe']['source'].lower().replace(' ', ''))
                print(x['recipe']['url'])
            self.gui.show_page("SearchRecipe.qml")
            self.speak_dialog("found.recipes", data={
                              "number": resultCount, "query": searchString})
        else:
            self.speak_dialog("failed.search")

    @intent_file_handler('show.recipe.intent')
    def handle_show_recipes_voice_intent(self, message):
        """
        Show Recipes By Voice
        
        Args:
            message: Mycroft Message
        """
        utterance = message.data.get('name').lower()
        searchString = utterance
        searchString = re.sub(r'\W+', '', searchString)
        searchString = searchString.lower()
        
        for recipe in self.recipes_object['hits']:
            recipe_match_string = recipe['recipe']['label']
            recipe_match_string = re.sub(r'\W+', '', recipe_match_string)
            recipe_match_string = recipe_match_string.lower()
            
            if len(searchString.split()) <= 2:
                if searchString == recipe_match_string:
                    self.handle_show_recipes(Message("foodwizard.showrecipe", data={"recipe": recipe['recipe']['url']}))
            
            else:
                if len(set(searchString.split()) & set(recipe_match_string.split())) > 2:
                    self.handle_show_recipes(Message("foodwizard.showrecipe", data={"recipe": recipe['recipe']['url']}))

    def handle_show_recipes(self, message):
        """
        Show Recipes By Keywords
        
        Args:
            message: Mycroft Message
        """
        foodTitle = message.data["recipe"]
        for x in self.recipes_object['hits']:
            if x['recipe']['url'] == foodTitle:
                recipeTitle = x['recipe']['label']
                recipeHealthTag = x['recipe']['healthLabels']
                recipeCalories = x['recipe']['calories']
                recipeImage = x['recipe']['image']
                recipeDietType = x['recipe']['dietLabels']
                recipeDietTypeArray = {"dietTags": recipeDietType}
                recipeIngredientsList = self.build_ingredients_list(
                    x['recipe']['ingredients'])
                recipeSource = x['recipe']['source']
                source_modif = recipeSource.lower().replace(' ', '')
                recipeInstructions = self.provider_helper.get_recipe_instructions(
                    source_modif, x['recipe']['url'])

                self.gui["recipeTitle"] = recipeTitle
                self.gui["recipeHealthTag"] = recipeHealthTag
                self.gui["recipeCalories"] = recipeCalories
                self.gui["recipeImage"] = recipeImage
                self.gui["recipeDietType"] = recipeDietTypeArray
                self.gui["recipeIngredients"] = recipeIngredientsList
                self.gui["recipeSource"] = recipeSource
                if recipeInstructions:
                    self.gui["hasInstructions"] = True
                    self.gui["recipeInstructions"] = recipeInstructions
                else:
                    self.gui["hasInstructions"] = False
                    self.gui["recipeInstructions"] = []
                self.active_recipe = recipeTitle
                self.gui.show_page("RecipeDetail.qml", override_idle=True)

    @intent_file_handler('read.current.recipe.ingredients.intent')
    def handle_read_current_recipe_ingredients_intent(self, message):
        """ 
        Read Current Recipe Ingredients
        
        Args:
            message: Mycroft Message
        """
        if self.active_recipe:
            for x in self.recipes_object['hits']:
                if x['recipe']['label'] == self.active_recipe:
                    recipeIngredientsList = self.build_ingredients_list(
                        x['recipe']['ingredients'])
                    for ingredient in recipeIngredientsList:
                        self.speak(ingredient.get("name"))

    @intent_file_handler('read.current.recipe.instructions.intent')
    def handle_read_current_recipe_instructions_intent(self, message):
        """ 
        Read Current Recipe Instructions
        
        Args:
            message: Mycroft Message
        """
        if self.active_recipe:
            for x in self.recipes_object['hits']:
                if x['recipe']['label'] == self.active_recipe:
                    recipeSource = x['recipe']['source']
                    source_modif = recipeSource.lower().replace(' ', '')
                    recipeInstructions = self.provider_helper.get_recipe_instructions(
                        source_modif, x['recipe']['url'])
                    if recipeInstructions:
                        for instruction in recipeInstructions:
                            speak_instruction = instruction.get('step', '')
                            self.speak(speak_instruction)
                    else:
                        self.speak_dialog('no.instructions')

    def build_ingredients_list(self, ingredients):
        """
        Build Ingredients List
        
        Args:
            message: Mycroft Message
        """
        ingredients_list = []
        for ingredient in ingredients:
            ingredient_name = ingredient['text']
            ingredient_image = ingredient['image']
            ingredient_quantity = ingredient['quantity']
            ingredients_list.append(
                {'name': ingredient_name,
                 'image': ingredient_image,
                 'quantity': ingredient_quantity})
        return ingredients_list

    def use_direct_api(self, query):
        """ 
        Use Direct API
        
        Args:
            query: Search Query
        """
        method = "GET"
        url = "https://api.edamam.com/search"
        data = f"?q={query}&app_id={self.app_id}&app_key={self.app_key}&count=5"
        response = requests.request(method, url+data)
        return response.json()

    def use_ovos_api(self, query):
        """ 
        Use OVOS API
        
        Args:
            query: Search Query
        """
        method = "GET"
        url = "https://api.openvoiceos.com/recipes/search_recipe"
        data = f"?query={query}&count=5"
        response = requests.request(method, url+data)
        return response.json()

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
