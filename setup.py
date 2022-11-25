#!/usr/bin/env python3
from setuptools import setup
import os
from os import walk, path

URL = "https://github.com/aiix/food-wizard"
SKILL_CLAZZ = "FoodWizardSkill"  # needs to match __init__.py class name
PYPI_NAME = "food-wizard"  # pip install PYPI_NAME

BASEDIR = os.path.abspath(os.path.dirname(__file__))
SKILL_AUTHOR, SKILL_NAME = URL.split(".com/")[-1].split("/")
SKILL_PKG = SKILL_NAME.lower().replace('-', '_')
PLUGIN_ENTRY_POINT = f'{SKILL_NAME.lower()}.{SKILL_AUTHOR.lower()}={SKILL_PKG}:{SKILL_CLAZZ}'


def get_requirements(requirements_filename: str):
    requirements_file = path.join(path.abspath(path.dirname(__file__)),
                                  requirements_filename)
    with open(requirements_file, 'r', encoding='utf-8') as r:
        requirements = r.readlines()
    requirements = [r.strip() for r in requirements if r.strip()
                    and not r.strip().startswith("#")]
    if 'MYCROFT_LOOSE_REQUIREMENTS' in os.environ:
        print('USING LOOSE REQUIREMENTS!')
        requirements = [r.replace('==', '>=').replace('~=', '>=') for r in requirements]
    return requirements


def find_resource_files():
    resource_base_dirs = ("locale", "ui", "vocab", "dialog", "regex", "skill")
    base_dir = path.dirname(__file__)
    package_data = ["*.json"]
    for res in resource_base_dirs:
        if path.isdir(path.join(base_dir, res)):
            for (directory, _, files) in walk(path.join(base_dir, res)):
                if files:
                    package_data.append(
                        path.join(directory.replace(base_dir, "").lstrip('/'),
                                  '*'))
    return package_data

setup(
    # this is the package name that goes on pip
    name=PYPI_NAME,
    version='0.0.1',
    description='Recipes Skill Plugin',
    url='https://github.com/AIIX/food-wizard',
    author='Aix',
    author_email='aix.m@outlook.com',
    license='Apache-2.0',
    package_dir={SKILL_PKG: ""},
    package_data={SKILL_PKG: find_resource_files()},
    packages=[SKILL_PKG],
    include_package_data=True,
    install_requires=get_requirements("requirements.txt"),
    keywords='ovos recipes skill plugin',
    data_files = [
        ('share/applications', ['res/desktop/food-wizard.desktop']),
        ('share/icons', ['res/icon/foodwizz.png'])
    ],
    entry_points={'ovos.plugin.skill': PLUGIN_ENTRY_POINT}
)
