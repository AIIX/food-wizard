#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# Copyright (c) 2016 - 2022 by Aditya Mehra <Aix.m@outlook.com>
# All rights reserved.

from bs4 import BeautifulSoup
import json
import cloudscraper


class ProviderHelper:
    def __init__(self) -> None:
        pass

    def get_recipe_instructions(self, source, source_url):
        results = []
        final_results = []
        scraper = cloudscraper.create_scraper()
        resp = scraper.get(source_url)
        soup = BeautifulSoup(resp.text, "html.parser")
        results = self.get_provider_result(source, soup)

        for item in results:
            if item not in final_results:
                final_results.append({"step": item})

        return final_results

    def get_provider_result(self, provider_source, soup):
        try:
            results = []
            if provider_source == 'food52':
                extractor = soup.find("div", {"class": "recipe__list--steps"})
                steps = extractor.find_all("li")

                for step in steps:
                    results.append(step.text)

            if provider_source == 'epicurious':
                extractor = soup.find(
                    "script", {"type": "application/ld+json"})
                json_data = json.loads(extractor.contents[0])
                steps = json_data["recipeInstructions"]

                for step in steps:
                    text = step.get("text", "")
                    results.append(text)

            if provider_source == "seriouseats":
                extractor = soup.findAll(
                    "script", {"type": "application/ld+json"})
                data_source = extractor[0].contents[0]
                json_data = json.loads(data_source)
                for data in json_data:
                    steps = data.get("recipeInstructions", "")
                    if steps:
                        for step in steps:
                            text = step.get("text", "")
                            results.append(text)

            if provider_source == "marthastewart":
                extractor = soup.find("ul", {"class": "instructions-section"})
                steps = extractor.find_all("li")

                for step in steps:
                    step_additional_a = step.find(
                        "div", {"class": "section-body"})
                    step_additional_b = step_additional_a.find("p")
                    results.append(step_additional_b.text)

            if provider_source == "whiteonricecouple":
                extractor = soup.find(
                    "script", {"type": "application/ld+json"})
                json_data = json.loads(extractor.contents[0])
                data_filter = json_data["@graph"]
                for data in data_filter:
                    if data["@type"] == "Recipe":
                        steps = data["recipeInstructions"]
                        for step in steps:
                            results.append(step.get("text", ""))

            if provider_source == "bonappetit":
                extractor = soup.find(
                    "script", {"type": "application/ld+json"})
                json_data = json.loads(extractor.contents[0])
                steps = json_data["recipeInstructions"]

                for step in steps:
                    text = step.get("text", "")
                    results.append(text)

            if provider_source == "tastingtable":
                extractor = soup.findAll(
                    "script", {"type": "application/ld+json"})
                json_data = json.loads(extractor[1].contents[0])
                steps = json_data["recipeInstructions"]

                for step in steps:
                    text = step.get("text", "")
                    results.append(text)

            if provider_source == "honestcooking":
                extractor = soup.find_all(
                    "li", {"itemprop": "recipeInstructions"})
                for step in extractor:
                    results.append(step.text)

            if provider_source == "foodandwine":
                extractor = soup.find(
                    "script", {"type": "application/ld+json"})
                data = json.loads(extractor.contents[0])
                json_data = data[0]
                steps = json_data["recipeInstructions"]

                for step in steps:
                    text = step.get("text", "")
                    results.append(text)

            if provider_source == "eatingwell":
                exctractor = soup.find(
                    "script", {"type": "application/ld+json"})
                data = json.loads(exctractor.contents[0])
                json_data = data[1]
                steps = json_data["recipeInstructions"]

                for step in steps:
                    text = step.get("text", "")
                    results.append(text)

            if provider_source == "cookstr":
                extractor = soup.findAll(
                    "script", {"type": "application/ld+json"})
                json_data = json.loads(extractor[1].contents[0])
                steps = json_data["recipeInstructions"]

                for step in steps:
                    text = step.get("text", "")
                    results.append(text)

            if provider_source == "bbcgoodfood":
                exctractor = soup.find(
                    "script", {"type": "application/ld+json"})
                data = json.loads(exctractor.contents[0])
                steps = data["recipeInstructions"]

                for step in steps:
                    text = step.get("text", "")
                    results.append(text)

            if provider_source == "delish":
                exctractor = soup.find(
                    "script", {"type": "application/ld+json"})
                data = json.loads(exctractor.contents[0])
                steps = data["recipeInstructions"]

                for step in steps:
                    text = step.get("text", "")
                    results.append(text)

            if provider_source == "pioneerwoman":
                exctractor = soup.find(
                    "script", {"type": "application/ld+json"})
                data = json.loads(exctractor.contents[0])
                steps = data["recipeInstructions"]

                for step in steps:
                    text = step.get("text", "")
                    results.append(text)

            if provider_source == "foodnetwork":
                exctractor = soup.find(
                    "script", {"type": "application/ld+json"})
                data = json.loads(exctractor.contents[0])
                json_data = data[0]
                steps = json_data["recipeInstructions"]

                for step in steps:
                    text = step.get("text", "")
                    results.append(text)

            if provider_source == "closetcooking":
                exctractor = soup.find("ol", {"class": "instructions"})
                steps = exctractor.find_all("li")

                for step in steps:
                    results.append(step.text)

            if provider_source == "cookalmostanything":
                exctractor = soup.find("div", {"class": "post-body"})
                for s in exctractor.find_all("center"):
                    s.decompose()
                steps = exctractor.get_text().split("<br>")
                for step in steps:
                    results.append(step)

            if provider_source == "bbc":
                exctractor = soup.findAll(
                    "script", {"type": "application/ld+json"})
                for data in exctractor:
                    json_data = json.loads(data.contents[0])
                    if "recipeInstructions" in json_data:
                        steps = json_data["recipeInstructions"]
                        for step in steps:
                            results.append(step)

            if provider_source == "foodrepublic":
                exctractor = soup.find(
                    "span", {"itemprop": "recipeInstructions"})
                steps = exctractor.find_all("li")

                for step in steps:
                    results.append(step.text)

            if provider_source == "simplyrecipes":
                exctractor = soup.findAll(
                    "script", {"type": "application/ld+json"})
                for data in exctractor:
                    json_data = json.loads(data.contents[0])
                    data = json_data[0]
                    if "recipeInstructions" in data:
                        steps = data["recipeInstructions"]
                        for step in steps:
                            results.append(step.get("text", ""))

            if provider_source == "latimes":
                exctractor = soup.findAll(
                    "script", {"type": "application/ld+json"})
                for data in exctractor:
                    json_data = json.loads(data.contents[0])
                    if "recipeInstructions" in json_data:
                        steps = json_data["recipeInstructions"]
                        for step in steps:
                            results.append(step.get("text", ""))

            if provider_source == "thedailymeal":
                exctractor = soup.find("ol", {"class": "recipe-directions"})
                steps = exctractor.find_all("li")

                for step in steps:
                    results.append(step.text)

            if provider_source == "saveur":
                exctractor = soup.findAll(
                    "script", {"type": "application/ld+json"})
                for data in exctractor:
                    json_data = json.loads(data.contents[0])
                    if "recipeInstructions" in json_data:
                        steps = json_data["recipeInstructions"]
                        for step in steps:
                            results.append(step.get("text", ""))

            if provider_source == "frenchrevolutionfood":
                exctractor = soup.find("div", {"class": "recipe"})
                orderedlist = exctractor.find_all("ol")
                steps = orderedlist[0].find_all("li")

                for step in steps:
                    results.append(step.text)

            if provider_source == "food.com":
                exctractor = soup.findAll(
                    "script", {"type": "application/ld+json"})
                for data in exctractor:
                    json_data = json.loads(data.contents[0])
                    if "recipeInstructions" in json_data:
                        steps = json_data["recipeInstructions"]
                        for step in steps:
                            results.append(step.get("text", ""))

            if provider_source == "foodista":
                exctractor = soup.findAll("div", {"class": "step-body"})
                for step in exctractor:
                    results.append(step.text)

            if provider_source == "turniptheoven.com":
                extractor = soup.find("ol", {"itemprop": "recipeInstructions"})
                steps = extractor.find_all("li")

                for step in steps:
                    results.append(step.text)

            if provider_source == "tastykitchen.com":
                exctractor = soup.find("span", {"itemprop": "instructions"})
                steps = exctractor.find_all("p")

                for step in steps:
                    results.append(step.text)

            if provider_source == "nomnompaleo":
                exctractor = soup.findAll(
                    "script", {"type": "application/ld+json"})
                for data in exctractor:
                    json_data = json.loads(data.contents[0])
                    graph_data = json_data["@graph"]
                    for data in graph_data:
                        if "recipeInstructions" in data:
                            steps = data["recipeInstructions"]
                            for step in steps:
                                results.append(step.get("text", ""))

            if provider_source == "justapinch.com":
                exctractor = soup.findAll(
                    "script", {"type": "application/ld+json"})
                for data in exctractor:
                    json_data = json.loads(data.contents[0])
                    if "recipeInstructions" in json_data:
                        steps = json_data["recipeInstructions"]
                        for step in steps:
                            results.append(step)

            if provider_source == "foxeslovelemons.com":
                exctractor = soup.findAll(
                    "script", {"type": "application/ld+json"})
                for data in exctractor:
                    json_data = json.loads(data.contents[0])
                    if "recipeInstructions" in json_data:
                        steps = json_data["recipeInstructions"]
                        for step in steps:
                            results.append(step.get("text", ""))

            results = [item.strip() for item in results if item.strip()]
            return results

        except Exception as e:
            print("Error Getting Recipe Instructions: %s", e)
            return []
