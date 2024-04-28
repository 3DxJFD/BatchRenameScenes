module IDKProgramming
  module BatchRenameScenes
    extend self

    PREF_KEY ||= Module.nesting[0].name.gsub('::', '_')
    PLUGIN_PATH ||= File.dirname(__FILE__)
    PLUGIN_PATH_HTML ||= File.join(PLUGIN_PATH, 'html')
    PLUGIN_PATH_ICONS ||= File.join(PLUGIN_PATH, 'icons')

    def show_html_dialog
      @dialog ||= create_dialog
      @dialog.set_html(generate_html_with_data(current_scenes_data)) # Force refresh the HTML content with current scene data
      attach_callbacks(@dialog) unless @dialog.visible?
      @dialog.visible? ? @dialog.bring_to_front : @dialog.show
    end

    def current_scenes_data
      model = Sketchup.active_model
      scenes = model.pages.map.with_index(1) { |page, idx| { name: page.name, index: idx } }
      scenes
    end

    def create_dialog
      UI::HtmlDialog.new({
        dialog_title: "Batch Rename Scenes",
        preferences_key: PREF_KEY,
        scrollable: true,
        resizable: true,
        width: 300,
        height: 400,
        left: 100,
        top: 100,
        style: UI::HtmlDialog::STYLE_DIALOG
      }).tap { |dialog| dialog.set_file(File.join(PLUGIN_PATH_HTML, 'batch-rename-scenes.html')) }
    end

    def attach_callbacks(dialog)
      dialog.add_action_callback("closeDialog") { dialog.close }
      dialog.add_action_callback("performActionOnSelectedScenes") do |_, data|
        selected_scene_names, base_name = data.split('|')
        rename_selected_scenes(selected_scene_names.split(','), base_name)
      end
      dialog.add_action_callback("requestUpdatedScenes") do |_, _|
        updated_scenes_json = get_updated_scenes_json
        dialog.execute_script("updateScenesList(#{updated_scenes_json});")
      end
    end

    def rename_selected_scenes(scene_names, base_name)
      model = Sketchup.active_model
      model.pages.each_with_index do |page, idx|
        if scene_names.include?(page.name)
          page.name = "#{base_name} #{idx + 1}"
        end
      end
    end

    def generate_html_with_data(scenes)
      html_path = File.join(PLUGIN_PATH_HTML, 'batch-rename-scenes.html')
      html_content = File.read(html_path)
      updated_html = html_content.gsub('var scenes = [];', "var scenes = #{scenes.to_json};")
      #puts "Updated HTML content: #{updated_html}"
      updated_html
    end
    
    def get_updated_scenes_json
      model = Sketchup.active_model
      scenes = model.pages.map.with_index(1) { |page, idx| { name: page.name, index: idx } }
      scenes_json = scenes.to_json
      #puts "Updated Scenes JSON: #{scenes_json}" 
      scenes_json
    end
    
    def initialize_toolbar
      toolbar = UI::Toolbar.new("Batch Rename Scenes")
      toolbar.add_item(create_command("Batch Rename Scenes", 'BatchRenameScenes.png', method(:show_html_dialog)))
      toolbar.add_item(create_command("Donate", 'beer.png', -> { UI.openURL("https://paypal.me/DezmoHU") }))
      toolbar.show
    end

    def create_command(tooltip, icon_name, command_proc)
      cmd = UI::Command.new(tooltip, &command_proc)
      icon_path = File.join(PLUGIN_PATH_ICONS, icon_name)
      cmd.small_icon = cmd.large_icon = icon_path
      cmd.tooltip = cmd.status_bar_text = tooltip
      cmd
    end

    initialize_toolbar
    UI.menu("Extensions").add_item("Batch Rename Scenes") { show_html_dialog }
  end
end
