#!/usr/bin/env python3
import os
from setuptools import setup

BASEDIR = os.path.abspath(os.path.dirname(__file__))

def required(requirements_file):
    """ Read requirements file and remove comments and empty lines. """
    with open(os.path.join(BASEDIR, requirements_file), 'r') as f:
        requirements = f.read().splitlines()
        if 'MYCROFT_LOOSE_REQUIREMENTS' in os.environ:
            print('USING LOOSE REQUIREMENTS!')
            requirements = [r.replace('==', '>=').replace('~=', '>=') for r in requirements]
        return [pkg for pkg in requirements
                if pkg.strip() and not pkg.startswith("#")]

# skill_id=package_name:SkillClass
PLUGIN_ENTRY_POINT = 'food-wizard.aiix=food_wizard:FoodWizardSkill'

setup(
    # this is the package name that goes on pip
    name='food-wizard',
    version='0.0.1',
    description='Recipes skill plugin',
    url='https://github.com/AIIX/food-wizard',
    author='AIIX',
    author_email='aix.m@outlook.com',
    license='Apache-2.0',
    package_dir={"food_wizard": ""},
    package_data={'food_wizard': ['vocab/en-us/*', "ui/*", "ui/+mediacenter/*", "res/desktop/*", "res/icon/*", "test/intent/*"]},
    packages=['food_wizard'],
    include_package_data=True,
    install_requires=required("requirements.txt"),
    keywords='ovos recipes skill plugin',
    entry_points={'ovos.plugin.skill': PLUGIN_ENTRY_POINT}
)
