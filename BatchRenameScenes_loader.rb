module IDK_Programming
    module BatchRenameScenes
      
    # Define PLUGIN_PATH constant
    PLUGIN_PATH ||= File.dirname(__FILE__)

    # Require the main.rb file
    require File.join(PLUGIN_PATH, 'main.rb')

    # Define other constants
    PLUGIN_PATH_IMAGE = File.join(PLUGIN_PATH, 'icons')
    PLUGIN_PATH_HTML = File.join(PLUGIN_PATH, 'html')
  
  end
end