module IDK_Programming
    module BatchRenameScenes
        
        def self.show_dialog
            dialog = UI::HtmlDialog.new(
              {
                :dialog_title => "Batch Rename Scenes",
                :preferences_key => "com.example.BatchRenameScenes",
                :scrollable => true,
                :width => 100,
                :height => 100,
                :left => 100,
                :top => 100,
                :resizable => true,
                :style => UI::HtmlDialog::STYLE_DIALOG
              }
            )
          
            model = Sketchup.active_model
            scene_data = model.pages.map.with_index(1) { |scene, index| { name: scene.name, index: index } }
            scene_json = scene_data.to_json

            html_file_path = File.join(PLUGIN_PATH_HTML, 'BatchRenameScenes.html')
            html_content = File.read(html_file_path)
            # Replace a placeholder in the HTML with the scene JSON data
            html_content_with_data = html_content.gsub('var scenes = [];', "var scenes = #{scene_json};")
            dialog.set_html(html_content_with_data)

            dialog.add_action_callback("closeDialog") do |context, _params|
                dialog.close
            end

            dialog.add_action_callback("performActionOnSelectedScenes") do |context, data|
                puts "Received data: #{data.inspect}"  # This will print the data
                selected_scene_names, base_name = data.split('|')
                scene_names_array = selected_scene_names.split(',')
                rename_selected_scenes(scene_names_array, base_name)
            end

            dialog.add_action_callback("requestUpdatedScenes") do |context, _params|
                updated_scenes_json = get_updated_scenes_json()
                dialog.execute_script("updateScenesList(#{updated_scenes_json});")
            end
            
            dialog.show
        end
        
        def self.initialize_toolbar
            toolbar = UI::Toolbar.new("Batch Rename Scenes")
            add_rename_button(toolbar)
            add_beer_button(toolbar)
            toolbar.show
        end

        def self.rename_selected_scenes(scene_names, base_name)
            puts "Scene names: #{scene_names.inspect}, Base name: #{base_name.inspect}"
            model = Sketchup.active_model
            counter = 1
        
            model.pages.each do |scene|
                if scene_names.include?(scene.name)
                    new_scene_name = "#{base_name} #{counter}"
                    scene.name = new_scene_name
                    counter += 1
                end
            end
        end

        def self.get_updated_scenes_json
            model = Sketchup.active_model
            updated_scene_data = model.pages.map.with_index(1) { |scene, index| { name: scene.name, index: index } }
            updated_scene_data.to_json
        end

        # Existing command for Batch Rename Scenes
        def self.add_rename_button(toolbar)
            rename_cmd = UI::Command.new("Batch Rename Scenes") { BatchRenameScenes.show_dialog }
            icon_path = File.join(File.dirname(__FILE__), 'icons', 'BatchRenameScenes.png')
            rename_cmd.small_icon = icon_path
            rename_cmd.large_icon = icon_path
            rename_cmd.tooltip = "Batch Rename Scenes"
            toolbar = toolbar.add_item(rename_cmd)
        end

        # Command for Beer button - added link.
        def self.add_beer_button(toolbar)
            beer_cmd = UI::Command.new("Donate") {
                UI.openURL("https://paypal.me/DezmoHU")
            }
            beer_icon_path = File.join(File.dirname(__FILE__), 'icons', 'beer.png')
            beer_cmd.small_icon = beer_icon_path
            beer_cmd.large_icon = beer_icon_path
            beer_cmd.tooltip = "Donate"
            toolbar = toolbar.add_item(beer_cmd)
        end

        self.initialize_toolbar
        UI.menu("Extensions").add_item("Batch Rename Scenes") { BatchRenameScenes.show_dialog }

    end
end
  