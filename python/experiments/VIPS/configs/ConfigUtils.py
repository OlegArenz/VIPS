import os
import numpy as np

class ConfigUtils:
    @staticmethod
    def merge_config(original, new):
        if hasattr(new, 'COMMON'):
            ConfigUtils.merge_COMMON(original, new.COMMON)
        if hasattr(new, 'LTS'):
            ConfigUtils.merge_LTS(original, new.LTS)
        if hasattr(new, 'WEIGHT_OPTIMIZATION'):
            ConfigUtils.merge_WEIGHT_OPTIMIZATION(original, new.WEIGHT_OPTIMIZATION)
        if hasattr(new, 'COMPONENT_OPTIMIZATION'):
            ConfigUtils.merge_COMPONENT_OPTIMIZATION(original, new.COMPONENT_OPTIMIZATION)
        if hasattr(new, 'PLOTTING'):
            ConfigUtils.merge_PLOTTING(original, new.PLOTTING)
        if hasattr(new, 'FUNCTIONS'):
            ConfigUtils.merge_FUNCTIONS(original, new.FUNCTIONS)

    @staticmethod
    def merge_COMMON(original, new):
        for key in new:
            original.COMMON[key] = new[key]

    @staticmethod
    def merge_LTS(original, new):
        for key in new:
            original.LTS[key] = new[key]

    @staticmethod
    def merge_WEIGHT_OPTIMIZATION(original, new):
        for key in new:
            original.WEIGHT_OPTIMIZATION[key] = new[key]

    @staticmethod
    def merge_COMPONENT_OPTIMIZATION(original, new):
        for key in new:
            original.COMPONENT_OPTIMIZATION[key] = new[key]

    @staticmethod
    def merge_PLOTTING(original, new):
        for key in new:
            original.PLOTTING[key] = new[key]

    @staticmethod
    def merge_FUNCTIONS(original, new):
        for key in new:
            original.FUNCTIONS[key] = new[key]

    @staticmethod
    def enable_progress_logging(path, config, rate):
        if not os.path.exists(path):
            os.makedirs(path)
        config.COMMON['progress_path'] = path
        config.COMMON['progress_rate'] = rate
