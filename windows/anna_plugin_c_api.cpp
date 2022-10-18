#include "include/anna/anna_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "anna_plugin.h"

void AnnaPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  anna::AnnaPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
