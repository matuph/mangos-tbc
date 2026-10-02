# Build/runtime extension; lifecycle is handled by the companion core hooks.
add_library(eluna INTERFACE)
target_compile_definitions(eluna INTERFACE BUILD_ELUNA ELUNA_CMANGOS ELUNA_EXPANSION=1)
target_include_directories(eluna INTERFACE ${CMAKE_SOURCE_DIR}/src/game/LuaEngine/hooks)
target_link_libraries(eluna INTERFACE lualib)
# All modules must see identical Object/Player class layouts.
target_link_libraries(shared PUBLIC eluna)
target_link_libraries(game PRIVATE eluna)
target_link_libraries(mangosd eluna)
if(TARGET playerbots)
  set_property(TARGET playerbots APPEND PROPERTY LINK_LIBRARIES eluna)
  set_property(TARGET playerbots APPEND PROPERTY INTERFACE_LINK_LIBRARIES eluna)
endif()
install(FILES lua_scripts/eluna_module_check.lua DESTINATION ${CMAKE_INSTALL_PREFIX}/lua_scripts)
