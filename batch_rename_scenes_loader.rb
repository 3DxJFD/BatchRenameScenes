module IDKProgramming
  module BatchRenameScenes
    
    # Define the plugin path constant
    PLUGIN_PATH ||= File.dirname(__FILE__)

    # Require the main functionality file
    require File.join(PLUGIN_PATH, 'batch_rename_scenes_main.rb')

    # Define additional resource path constants
    PLUGIN_PATH_IMAGE = File.join(PLUGIN_PATH, 'icons').freeze
  
  end
end
