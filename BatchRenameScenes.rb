module IDK_Programming
    module BatchRenameScenes
  
    EXTENSION = SketchupExtension.new(
      'BatchRenameScenes',  # The name of the extension as it will appear in SketchUp
      'BatchRenameScenes/BatchRenameScenes_loader'  # The path to the loader file
    )
    EXTENSION.instance_eval {
      self.description= 'Adds an extension for naming and numbering scenes.'
      self.version=     '1.0.0'
      self.copyright=   "©2023 under If it's for free, it's for me."
      self.creator=     'IDK_Programming / SU Community'
    }
    Sketchup.register_extension(EXTENSION, true) 
  
  end # extension submodule
end # top level namespace module