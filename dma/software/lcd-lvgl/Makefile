#------------------------------------------------------------------------------
#              VARIABLES APPENDED TO BY INCLUDED MAKEFILE FRAGMENTS
#------------------------------------------------------------------------------

# List of include directories for -I compiler option (-I added when used).
# Includes the BSP.
ALT_INCLUDE_DIRS :=

# List of library directories for -L linker option (-L added when used).
# Includes the BSP.
ALT_LIBRARY_DIRS :=

# List of library names for -l linker option (-l added when used).
# Includes the BSP.
ALT_LIBRARY_NAMES :=

# List of library names for -msys-lib linker option (-msys-lib added when used).
# These are libraries that might be located in the BSP and depend on the BSP
# library, or vice versa
ALT_BSP_DEP_LIBRARY_NAMES :=

# List of dependencies for the linker.  This is usually the full pathname
# of each library (*.a) file.
# Includes the BSP.
ALT_LDDEPS :=

# List of root library directories that support running make to build them.
# Includes the BSP and any ALT libraries.
MAKEABLE_LIBRARY_ROOT_DIRS :=

# Generic flags passed to the compiler for different types of input files.
ALT_CFLAGS :=
ALT_CXXFLAGS :=
ALT_CPPFLAGS :=
ALT_ASFLAGS :=
ALT_LDFLAGS :=


#------------------------------------------------------------------------------
#                         The adjust-path macro
# 
# If COMSPEC/ComSpec is defined, Make is launched from Windows through
# Cygwin.  The adjust-path macro converts absolute windows paths into
# unix style paths (Example: c:/dir -> /c/dir). This will ensture
# paths are readable by GNU Make.
#
# If COMSPEC/ComSpec is not defined, Make is launched from linux, and no 
# adjustment is necessary
#
#------------------------------------------------------------------------------

ifndef COMSPEC
ifdef ComSpec
COMSPEC = $(ComSpec)
endif # ComSpec
endif # COMSPEC

ifdef COMSPEC # if Windows OS

ifeq ($(MAKE_VERSION),3.81) 
#
# adjust-path/adjust-path-mixed for Mingw Gnu Make on Windows
#
# Example Usage:
# $(call adjust-path,c:/aaa/bbb) => /c/aaa/bbb
# $(call adjust-path-mixed,/c/aaa/bbb) => c:/aaa/bbb
# $(call adjust-path-mixed,/cygdrive/c/aaa/bbb) => c:/aaa/bbb
#

#
# adjust-path
#  - converts back slash characters into forward slashes 
#  - if input arg ($1) is an empty string then return the empty string
#  - if input arg ($1) does not contain the string ":/", then return input arg
#  - using sed, convert mixed path [c:/...] into mingw path [/c/...] 
define adjust-path
$(strip \
$(if $1,\
$(if $(findstring :/,$(subst \,/,$1)),\
$(shell echo $(subst \,/,$1) | sed -e 's,^\([a-zA-Z]\):/,/\1/,'),\
$(subst \,/,$1))))
endef

#
# adjust-path-mixed
#  - converts back slash characters into forward slashes 
#  - if input arg ($1) is an empty string then return the empty string
#  - if input arg ($1) does not begin with a forward slash '/' char, then 
#    return input arg
#  - using sed, convert mingw path [/c/...] or cygwin path [/c/cygdrive/...] 
#    into a mixed path [c:/...] 
define adjust-path-mixed 
$(strip \
$(if $1,\
$(if $(findstring $(subst \,/,$1),$(patsubst /%,%,$(subst \,/,$1))),\
$(subst \,/,$1),\
$(shell echo $(subst \,/,$1) | sed -e 's,^/cygdrive/\([a-zA-Z]\)/,\1:/,' -e 's,^/\([a-zA-Z]\)/,\1:/,'))))
endef

else # MAKE_VERSION != 3.81 (MAKE_VERSION == 3.80 or MAKE_VERSION == 3.79) 
#
#  adjust-path for Cygwin Gnu Make
# $(call adjust-path,c:/aaa/bbb) = /cygdrive/c/aaa/bbb
# $(call adjust-path-mixed,/cygdrive/c/aaa/bbb) = c:/aaa/bbb
#
adjust-path = $(if $1,$(shell cygpath -u "$1"),)
adjust-path-mixed = $(if $1,$(shell cygpath -m "$1"),)
endif

else # !COMSPEC

adjust-path = $1
adjust-path-mixed = $1

endif # COMSPEC


#vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
#                           GENERATED SETTINGS START                         v
#vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

#START GENERATED
ACTIVE_BUILD_CONFIG := default
BUILD_CONFIGS := default

# The following TYPE comment allows tools to identify the 'type' of target this 
# makefile is associated with. 
# TYPE: APP_MAKEFILE

# This following VERSION comment indicates the version of the tool used to 
# generate this makefile. A makefile variable is provided for VERSION as well. 
# ACDS_VERSION: 18.1
ACDS_VERSION := 18.1

# This following BUILD_NUMBER comment indicates the build number of the tool 
# used to generate this makefile. 
# BUILD_NUMBER: 625

# Define path to the application ELF. 
# It may be used by the makefile fragments so is defined before including them. 
# 
ELF := lcd-lvgl.elf

# Paths to C, C++, and assembly source files.
C_SRCS += lcd.c
C_SRCS += main.c
C_SRCS += timer.c
C_SRCS += lvgl/demos/benchmark/assets/img_benchmark_avatar.c
C_SRCS += lvgl/demos/benchmark/assets/img_benchmark_lvgl_logo_argb.c
C_SRCS += lvgl/demos/benchmark/assets/img_benchmark_lvgl_logo_rgb.c
C_SRCS += lvgl/demos/benchmark/assets/lv_font_benchmark_montserrat_12_aligned.c
C_SRCS += lvgl/demos/benchmark/assets/lv_font_benchmark_montserrat_14_aligned.c
C_SRCS += lvgl/demos/benchmark/assets/lv_font_benchmark_montserrat_16_aligned.c
C_SRCS += lvgl/demos/benchmark/assets/lv_font_benchmark_montserrat_18_aligned.c
C_SRCS += lvgl/demos/benchmark/assets/lv_font_benchmark_montserrat_20_aligned.c
C_SRCS += lvgl/demos/benchmark/assets/lv_font_benchmark_montserrat_24_aligned.c
C_SRCS += lvgl/demos/benchmark/assets/lv_font_benchmark_montserrat_26_aligned.c
C_SRCS += lvgl/demos/benchmark/lv_demo_benchmark.c
C_SRCS += lvgl/demos/gltf/lv_demo_gltf.c
C_SRCS += lvgl/demos/keypad_encoder/lv_demo_keypad_encoder.c
C_SRCS += lvgl/demos/lv_demos.c
C_SRCS += lvgl/demos/music/assets/img_lv_demo_music_btn_corner_large.c
C_SRCS += lvgl/demos/music/assets/img_lv_demo_music_btn_list_pause.c
C_SRCS += lvgl/demos/music/assets/img_lv_demo_music_btn_list_pause_large.c
C_SRCS += lvgl/demos/music/assets/img_lv_demo_music_btn_list_play.c
C_SRCS += lvgl/demos/music/assets/img_lv_demo_music_btn_list_play_large.c
C_SRCS += lvgl/demos/music/assets/img_lv_demo_music_btn_loop.c
C_SRCS += lvgl/demos/music/assets/img_lv_demo_music_btn_loop_large.c
C_SRCS += lvgl/demos/music/assets/img_lv_demo_music_btn_next.c
C_SRCS += lvgl/demos/music/assets/img_lv_demo_music_btn_next_large.c
C_SRCS += lvgl/demos/music/assets/img_lv_demo_music_btn_pause.c
C_SRCS += lvgl/demos/music/assets/img_lv_demo_music_btn_pause_large.c
C_SRCS += lvgl/demos/music/assets/img_lv_demo_music_btn_play.c
C_SRCS += lvgl/demos/music/assets/img_lv_demo_music_btn_play_large.c
C_SRCS += lvgl/demos/music/assets/img_lv_demo_music_btn_prev.c
C_SRCS += lvgl/demos/music/assets/img_lv_demo_music_btn_prev_large.c
C_SRCS += lvgl/demos/music/assets/img_lv_demo_music_btn_rnd.c
C_SRCS += lvgl/demos/music/assets/img_lv_demo_music_btn_rnd_large.c
C_SRCS += lvgl/demos/music/assets/img_lv_demo_music_corner_left.c
C_SRCS += lvgl/demos/music/assets/img_lv_demo_music_corner_left_large.c
C_SRCS += lvgl/demos/music/assets/img_lv_demo_music_corner_right.c
C_SRCS += lvgl/demos/music/assets/img_lv_demo_music_corner_right_large.c
C_SRCS += lvgl/demos/music/assets/img_lv_demo_music_cover_1.c
C_SRCS += lvgl/demos/music/assets/img_lv_demo_music_cover_1_large.c
C_SRCS += lvgl/demos/music/assets/img_lv_demo_music_cover_2.c
C_SRCS += lvgl/demos/music/assets/img_lv_demo_music_cover_2_large.c
C_SRCS += lvgl/demos/music/assets/img_lv_demo_music_cover_3.c
C_SRCS += lvgl/demos/music/assets/img_lv_demo_music_cover_3_large.c
C_SRCS += lvgl/demos/music/assets/img_lv_demo_music_icon_1.c
C_SRCS += lvgl/demos/music/assets/img_lv_demo_music_icon_1_large.c
C_SRCS += lvgl/demos/music/assets/img_lv_demo_music_icon_2.c
C_SRCS += lvgl/demos/music/assets/img_lv_demo_music_icon_2_large.c
C_SRCS += lvgl/demos/music/assets/img_lv_demo_music_icon_3.c
C_SRCS += lvgl/demos/music/assets/img_lv_demo_music_icon_3_large.c
C_SRCS += lvgl/demos/music/assets/img_lv_demo_music_icon_4.c
C_SRCS += lvgl/demos/music/assets/img_lv_demo_music_icon_4_large.c
C_SRCS += lvgl/demos/music/assets/img_lv_demo_music_list_border.c
C_SRCS += lvgl/demos/music/assets/img_lv_demo_music_list_border_large.c
C_SRCS += lvgl/demos/music/assets/img_lv_demo_music_logo.c
C_SRCS += lvgl/demos/music/assets/img_lv_demo_music_slider_knob.c
C_SRCS += lvgl/demos/music/assets/img_lv_demo_music_slider_knob_large.c
C_SRCS += lvgl/demos/music/assets/img_lv_demo_music_wave_bottom.c
C_SRCS += lvgl/demos/music/assets/img_lv_demo_music_wave_bottom_large.c
C_SRCS += lvgl/demos/music/assets/img_lv_demo_music_wave_top.c
C_SRCS += lvgl/demos/music/assets/img_lv_demo_music_wave_top_large.c
C_SRCS += lvgl/demos/music/lv_demo_music.c
C_SRCS += lvgl/demos/music/lv_demo_music_list.c
C_SRCS += lvgl/demos/music/lv_demo_music_main.c
C_SRCS += lvgl/demos/render/assets/img_render_arc_bg.c
C_SRCS += lvgl/demos/render/assets/img_render_lvgl_logo_argb8888.c
C_SRCS += lvgl/demos/render/assets/img_render_lvgl_logo_argb8888_premultiplied.c
C_SRCS += lvgl/demos/render/assets/img_render_lvgl_logo_i1.c
C_SRCS += lvgl/demos/render/assets/img_render_lvgl_logo_l8.c
C_SRCS += lvgl/demos/render/assets/img_render_lvgl_logo_rgb565.c
C_SRCS += lvgl/demos/render/assets/img_render_lvgl_logo_rgb565_swapped.c
C_SRCS += lvgl/demos/render/assets/img_render_lvgl_logo_rgb565a8.c
C_SRCS += lvgl/demos/render/assets/img_render_lvgl_logo_rgb888.c
C_SRCS += lvgl/demos/render/assets/img_render_lvgl_logo_xrgb8888.c
C_SRCS += lvgl/demos/render/lv_demo_render.c
C_SRCS += lvgl/demos/stress/lv_demo_stress.c
C_SRCS += lvgl/demos/vector_graphic/assets/img_demo_vector_avatar.c
C_SRCS += lvgl/demos/vector_graphic/lv_demo_vector_graphic.c
C_SRCS += lvgl/demos/widgets/assets/img_clothes.c
C_SRCS += lvgl/demos/widgets/assets/img_demo_widgets_avatar.c
C_SRCS += lvgl/demos/widgets/assets/img_demo_widgets_needle.c
C_SRCS += lvgl/demos/widgets/assets/img_lvgl_logo.c
C_SRCS += lvgl/demos/widgets/lv_demo_widgets.c
C_SRCS += lvgl/demos/widgets/lv_demo_widgets_analytics.c
C_SRCS += lvgl/demos/widgets/lv_demo_widgets_components.c
C_SRCS += lvgl/demos/widgets/lv_demo_widgets_profile.c
C_SRCS += lvgl/demos/widgets/lv_demo_widgets_shop.c
C_SRCS += lvgl/env_support/pikascript/pika_lv_point_t.c
C_SRCS += lvgl/env_support/pikascript/pika_lv_timer_t.c
C_SRCS += lvgl/env_support/pikascript/pika_lv_wegit.c
C_SRCS += lvgl/env_support/pikascript/pika_lvgl.c
C_SRCS += lvgl/env_support/pikascript/pika_lvgl_indev_t.c
C_SRCS += lvgl/env_support/pikascript/pika_lvgl_lv_event.c
C_SRCS += lvgl/env_support/pikascript/pika_lvgl_lv_obj.c
C_SRCS += lvgl/env_support/pikascript/pika_lvgl_lv_style_t.c
C_SRCS += lvgl/env_support/rt-thread/lv_rt_thread_port.c
C_SRCS += lvgl/env_support/rt-thread/squareline/lv_ui_entry.c
C_SRCS += lvgl/examples/anim/lv_example_anim_1.c
C_SRCS += lvgl/examples/anim/lv_example_anim_2.c
C_SRCS += lvgl/examples/anim/lv_example_anim_3.c
C_SRCS += lvgl/examples/anim/lv_example_anim_4.c
C_SRCS += lvgl/examples/anim/lv_example_anim_timeline_1.c
C_SRCS += lvgl/examples/assets/animimg001.c
C_SRCS += lvgl/examples/assets/animimg002.c
C_SRCS += lvgl/examples/assets/animimg003.c
C_SRCS += lvgl/examples/assets/emoji/img_emoji_F617.c
C_SRCS += lvgl/examples/assets/img_caret_down.c
C_SRCS += lvgl/examples/assets/img_cogwheel_argb.c
C_SRCS += lvgl/examples/assets/img_cogwheel_indexed16.c
C_SRCS += lvgl/examples/assets/img_cogwheel_rgb.c
C_SRCS += lvgl/examples/assets/img_hand.c
C_SRCS += lvgl/examples/assets/img_skew_strip.c
C_SRCS += lvgl/examples/assets/img_star.c
C_SRCS += lvgl/examples/assets/img_svg_img.c
C_SRCS += lvgl/examples/assets/imgbtn_left.c
C_SRCS += lvgl/examples/assets/imgbtn_mid.c
C_SRCS += lvgl/examples/assets/imgbtn_right.c
C_SRCS += lvgl/examples/event/lv_example_event_bubble.c
C_SRCS += lvgl/examples/event/lv_example_event_button.c
C_SRCS += lvgl/examples/event/lv_example_event_click.c
C_SRCS += lvgl/examples/event/lv_example_event_draw.c
C_SRCS += lvgl/examples/event/lv_example_event_streak.c
C_SRCS += lvgl/examples/event/lv_example_event_trickle.c
C_SRCS += lvgl/examples/get_started/lv_example_get_started_1.c
C_SRCS += lvgl/examples/get_started/lv_example_get_started_2.c
C_SRCS += lvgl/examples/get_started/lv_example_get_started_3.c
C_SRCS += lvgl/examples/get_started/lv_example_get_started_4.c
C_SRCS += lvgl/examples/grad/lv_example_grad_1.c
C_SRCS += lvgl/examples/grad/lv_example_grad_2.c
C_SRCS += lvgl/examples/grad/lv_example_grad_3.c
C_SRCS += lvgl/examples/grad/lv_example_grad_4.c
C_SRCS += lvgl/examples/layouts/flex/lv_example_flex_1.c
C_SRCS += lvgl/examples/layouts/flex/lv_example_flex_2.c
C_SRCS += lvgl/examples/layouts/flex/lv_example_flex_3.c
C_SRCS += lvgl/examples/layouts/flex/lv_example_flex_4.c
C_SRCS += lvgl/examples/layouts/flex/lv_example_flex_5.c
C_SRCS += lvgl/examples/layouts/flex/lv_example_flex_6.c
C_SRCS += lvgl/examples/layouts/grid/lv_example_grid_1.c
C_SRCS += lvgl/examples/layouts/grid/lv_example_grid_2.c
C_SRCS += lvgl/examples/layouts/grid/lv_example_grid_3.c
C_SRCS += lvgl/examples/layouts/grid/lv_example_grid_4.c
C_SRCS += lvgl/examples/layouts/grid/lv_example_grid_5.c
C_SRCS += lvgl/examples/layouts/grid/lv_example_grid_6.c
C_SRCS += lvgl/examples/libs/barcode/lv_example_barcode_1.c
C_SRCS += lvgl/examples/libs/bmp/lv_example_bmp_1.c
C_SRCS += lvgl/examples/libs/ffmpeg/lv_example_ffmpeg_1.c
C_SRCS += lvgl/examples/libs/ffmpeg/lv_example_ffmpeg_2.c
C_SRCS += lvgl/examples/libs/freetype/lv_example_freetype_1.c
C_SRCS += lvgl/examples/libs/freetype/lv_example_freetype_2.c
C_SRCS += lvgl/examples/libs/freetype/lv_example_freetype_3.c
C_SRCS += lvgl/examples/libs/gif/img_bulb_gif.c
C_SRCS += lvgl/examples/libs/gif/lv_example_gif_1.c
C_SRCS += lvgl/examples/libs/gltf/lv_example_gltf_1.c
C_SRCS += lvgl/examples/libs/gltf/lv_example_gltf_2.c
C_SRCS += lvgl/examples/libs/gstreamer/lv_example_gstreamer_1.c
C_SRCS += lvgl/examples/libs/libjpeg_turbo/lv_example_libjpeg_turbo_1.c
C_SRCS += lvgl/examples/libs/libpng/img_png_demo.c
C_SRCS += lvgl/examples/libs/libpng/lv_example_libpng_1.c
C_SRCS += lvgl/examples/libs/lodepng/img_wink_png.c
C_SRCS += lvgl/examples/libs/lodepng/lv_example_lodepng_1.c
C_SRCS += lvgl/examples/libs/qrcode/lv_example_qrcode_1.c
C_SRCS += lvgl/examples/libs/rlottie/lv_example_rlottie_1.c
C_SRCS += lvgl/examples/libs/rlottie/lv_example_rlottie_2.c
C_SRCS += lvgl/examples/libs/rlottie/lv_example_rlottie_approve.c
C_SRCS += lvgl/examples/libs/svg/lv_example_svg_1.c
C_SRCS += lvgl/examples/libs/svg/lv_example_svg_2.c
C_SRCS += lvgl/examples/libs/svg/lv_example_svg_3.c
C_SRCS += lvgl/examples/libs/tiny_ttf/lv_example_tiny_ttf_1.c
C_SRCS += lvgl/examples/libs/tiny_ttf/lv_example_tiny_ttf_2.c
C_SRCS += lvgl/examples/libs/tiny_ttf/lv_example_tiny_ttf_3.c
C_SRCS += lvgl/examples/libs/tiny_ttf/ubuntu_font.c
C_SRCS += lvgl/examples/libs/tjpgd/lv_example_tjpgd_1.c
C_SRCS += lvgl/examples/others/file_explorer/lv_example_file_explorer_1.c
C_SRCS += lvgl/examples/others/file_explorer/lv_example_file_explorer_2.c
C_SRCS += lvgl/examples/others/file_explorer/lv_example_file_explorer_3.c
C_SRCS += lvgl/examples/others/font_manager/lv_example_font_manager_1.c
C_SRCS += lvgl/examples/others/font_manager/lv_example_font_manager_2.c
C_SRCS += lvgl/examples/others/font_manager/lv_example_font_manager_3.c
C_SRCS += lvgl/examples/others/fragment/lv_example_fragment_1.c
C_SRCS += lvgl/examples/others/fragment/lv_example_fragment_2.c
C_SRCS += lvgl/examples/others/gestures/lv_example_gestures.c
C_SRCS += lvgl/examples/others/gridnav/lv_example_gridnav_1.c
C_SRCS += lvgl/examples/others/gridnav/lv_example_gridnav_2.c
C_SRCS += lvgl/examples/others/gridnav/lv_example_gridnav_3.c
C_SRCS += lvgl/examples/others/gridnav/lv_example_gridnav_4.c
C_SRCS += lvgl/examples/others/gridnav/lv_example_gridnav_5.c
C_SRCS += lvgl/examples/others/ime/lv_example_ime_pinyin_1.c
C_SRCS += lvgl/examples/others/ime/lv_example_ime_pinyin_2.c
C_SRCS += lvgl/examples/others/imgfont/lv_example_imgfont_1.c
C_SRCS += lvgl/examples/others/monkey/lv_example_monkey_1.c
C_SRCS += lvgl/examples/others/monkey/lv_example_monkey_2.c
C_SRCS += lvgl/examples/others/monkey/lv_example_monkey_3.c
C_SRCS += lvgl/examples/others/observer/lv_example_observer_1.c
C_SRCS += lvgl/examples/others/observer/lv_example_observer_2.c
C_SRCS += lvgl/examples/others/observer/lv_example_observer_3.c
C_SRCS += lvgl/examples/others/observer/lv_example_observer_4.c
C_SRCS += lvgl/examples/others/observer/lv_example_observer_5.c
C_SRCS += lvgl/examples/others/observer/lv_example_observer_6.c
C_SRCS += lvgl/examples/others/observer/lv_example_observer_7.c
C_SRCS += lvgl/examples/others/snapshot/lv_example_snapshot_1.c
C_SRCS += lvgl/examples/others/translation/lv_example_translation_1.c
C_SRCS += lvgl/examples/others/translation/lv_example_translation_2.c
C_SRCS += lvgl/examples/others/xml/lv_example_xml_1.c
C_SRCS += lvgl/examples/others/xml/lv_example_xml_2.c
C_SRCS += lvgl/examples/porting/lv_port_disp_template.c
C_SRCS += lvgl/examples/porting/lv_port_fs_template.c
C_SRCS += lvgl/examples/porting/lv_port_indev_template.c
C_SRCS += lvgl/examples/porting/lv_port_lcd_stm32_template.c
C_SRCS += lvgl/examples/porting/osal/lv_example_osal.c
C_SRCS += lvgl/examples/scroll/lv_example_scroll_1.c
C_SRCS += lvgl/examples/scroll/lv_example_scroll_2.c
C_SRCS += lvgl/examples/scroll/lv_example_scroll_3.c
C_SRCS += lvgl/examples/scroll/lv_example_scroll_4.c
C_SRCS += lvgl/examples/scroll/lv_example_scroll_5.c
C_SRCS += lvgl/examples/scroll/lv_example_scroll_6.c
C_SRCS += lvgl/examples/scroll/lv_example_scroll_7.c
C_SRCS += lvgl/examples/scroll/lv_example_scroll_8.c
C_SRCS += lvgl/examples/scroll/lv_example_scroll_9.c
C_SRCS += lvgl/examples/styles/lv_example_style_1.c
C_SRCS += lvgl/examples/styles/lv_example_style_10.c
C_SRCS += lvgl/examples/styles/lv_example_style_11.c
C_SRCS += lvgl/examples/styles/lv_example_style_12.c
C_SRCS += lvgl/examples/styles/lv_example_style_13.c
C_SRCS += lvgl/examples/styles/lv_example_style_14.c
C_SRCS += lvgl/examples/styles/lv_example_style_15.c
C_SRCS += lvgl/examples/styles/lv_example_style_16.c
C_SRCS += lvgl/examples/styles/lv_example_style_17.c
C_SRCS += lvgl/examples/styles/lv_example_style_18.c
C_SRCS += lvgl/examples/styles/lv_example_style_19.c
C_SRCS += lvgl/examples/styles/lv_example_style_2.c
C_SRCS += lvgl/examples/styles/lv_example_style_3.c
C_SRCS += lvgl/examples/styles/lv_example_style_4.c
C_SRCS += lvgl/examples/styles/lv_example_style_5.c
C_SRCS += lvgl/examples/styles/lv_example_style_6.c
C_SRCS += lvgl/examples/styles/lv_example_style_7.c
C_SRCS += lvgl/examples/styles/lv_example_style_8.c
C_SRCS += lvgl/examples/styles/lv_example_style_9.c
C_SRCS += lvgl/examples/widgets/animimg/lv_example_animimg_1.c
C_SRCS += lvgl/examples/widgets/arc/lv_example_arc_1.c
C_SRCS += lvgl/examples/widgets/arc/lv_example_arc_2.c
C_SRCS += lvgl/examples/widgets/arc/lv_example_arc_3.c
C_SRCS += lvgl/examples/widgets/arclabel/lv_example_arclabel_1.c
C_SRCS += lvgl/examples/widgets/bar/lv_example_bar_1.c
C_SRCS += lvgl/examples/widgets/bar/lv_example_bar_2.c
C_SRCS += lvgl/examples/widgets/bar/lv_example_bar_3.c
C_SRCS += lvgl/examples/widgets/bar/lv_example_bar_4.c
C_SRCS += lvgl/examples/widgets/bar/lv_example_bar_5.c
C_SRCS += lvgl/examples/widgets/bar/lv_example_bar_6.c
C_SRCS += lvgl/examples/widgets/bar/lv_example_bar_7.c
C_SRCS += lvgl/examples/widgets/button/lv_example_button_1.c
C_SRCS += lvgl/examples/widgets/button/lv_example_button_2.c
C_SRCS += lvgl/examples/widgets/button/lv_example_button_3.c
C_SRCS += lvgl/examples/widgets/buttonmatrix/lv_example_buttonmatrix_1.c
C_SRCS += lvgl/examples/widgets/buttonmatrix/lv_example_buttonmatrix_2.c
C_SRCS += lvgl/examples/widgets/buttonmatrix/lv_example_buttonmatrix_3.c
C_SRCS += lvgl/examples/widgets/calendar/lv_example_calendar_1.c
C_SRCS += lvgl/examples/widgets/calendar/lv_example_calendar_2.c
C_SRCS += lvgl/examples/widgets/canvas/lv_example_canvas_1.c
C_SRCS += lvgl/examples/widgets/canvas/lv_example_canvas_10.c
C_SRCS += lvgl/examples/widgets/canvas/lv_example_canvas_11.c
C_SRCS += lvgl/examples/widgets/canvas/lv_example_canvas_2.c
C_SRCS += lvgl/examples/widgets/canvas/lv_example_canvas_3.c
C_SRCS += lvgl/examples/widgets/canvas/lv_example_canvas_4.c
C_SRCS += lvgl/examples/widgets/canvas/lv_example_canvas_5.c
C_SRCS += lvgl/examples/widgets/canvas/lv_example_canvas_6.c
C_SRCS += lvgl/examples/widgets/canvas/lv_example_canvas_7.c
C_SRCS += lvgl/examples/widgets/canvas/lv_example_canvas_8.c
C_SRCS += lvgl/examples/widgets/canvas/lv_example_canvas_9.c
C_SRCS += lvgl/examples/widgets/chart/lv_example_chart_1.c
C_SRCS += lvgl/examples/widgets/chart/lv_example_chart_2.c
C_SRCS += lvgl/examples/widgets/chart/lv_example_chart_3.c
C_SRCS += lvgl/examples/widgets/chart/lv_example_chart_4.c
C_SRCS += lvgl/examples/widgets/chart/lv_example_chart_5.c
C_SRCS += lvgl/examples/widgets/chart/lv_example_chart_6.c
C_SRCS += lvgl/examples/widgets/chart/lv_example_chart_7.c
C_SRCS += lvgl/examples/widgets/chart/lv_example_chart_8.c
C_SRCS += lvgl/examples/widgets/checkbox/lv_example_checkbox_1.c
C_SRCS += lvgl/examples/widgets/checkbox/lv_example_checkbox_2.c
C_SRCS += lvgl/examples/widgets/dropdown/lv_example_dropdown_1.c
C_SRCS += lvgl/examples/widgets/dropdown/lv_example_dropdown_2.c
C_SRCS += lvgl/examples/widgets/dropdown/lv_example_dropdown_3.c
C_SRCS += lvgl/examples/widgets/image/lv_example_image_1.c
C_SRCS += lvgl/examples/widgets/image/lv_example_image_2.c
C_SRCS += lvgl/examples/widgets/image/lv_example_image_3.c
C_SRCS += lvgl/examples/widgets/image/lv_example_image_4.c
C_SRCS += lvgl/examples/widgets/image/lv_example_image_5.c
C_SRCS += lvgl/examples/widgets/imagebutton/lv_example_imagebutton_1.c
C_SRCS += lvgl/examples/widgets/keyboard/lv_example_keyboard_1.c
C_SRCS += lvgl/examples/widgets/keyboard/lv_example_keyboard_2.c
C_SRCS += lvgl/examples/widgets/keyboard/lv_example_keyboard_3.c
C_SRCS += lvgl/examples/widgets/label/lv_example_label_1.c
C_SRCS += lvgl/examples/widgets/label/lv_example_label_2.c
C_SRCS += lvgl/examples/widgets/label/lv_example_label_3.c
C_SRCS += lvgl/examples/widgets/label/lv_example_label_4.c
C_SRCS += lvgl/examples/widgets/label/lv_example_label_5.c
C_SRCS += lvgl/examples/widgets/label/lv_example_label_6.c
C_SRCS += lvgl/examples/widgets/label/lv_example_label_7.c
C_SRCS += lvgl/examples/widgets/led/lv_example_led_1.c
C_SRCS += lvgl/examples/widgets/line/lv_example_line_1.c
C_SRCS += lvgl/examples/widgets/list/lv_example_list_1.c
C_SRCS += lvgl/examples/widgets/list/lv_example_list_2.c
C_SRCS += lvgl/examples/widgets/lottie/lv_example_lottie_1.c
C_SRCS += lvgl/examples/widgets/lottie/lv_example_lottie_2.c
C_SRCS += lvgl/examples/widgets/lottie/lv_example_lottie_approve.c
C_SRCS += lvgl/examples/widgets/menu/lv_example_menu_1.c
C_SRCS += lvgl/examples/widgets/menu/lv_example_menu_2.c
C_SRCS += lvgl/examples/widgets/menu/lv_example_menu_3.c
C_SRCS += lvgl/examples/widgets/menu/lv_example_menu_4.c
C_SRCS += lvgl/examples/widgets/menu/lv_example_menu_5.c
C_SRCS += lvgl/examples/widgets/msgbox/lv_example_msgbox_1.c
C_SRCS += lvgl/examples/widgets/msgbox/lv_example_msgbox_2.c
C_SRCS += lvgl/examples/widgets/obj/lv_example_obj_1.c
C_SRCS += lvgl/examples/widgets/obj/lv_example_obj_2.c
C_SRCS += lvgl/examples/widgets/obj/lv_example_obj_3.c
C_SRCS += lvgl/examples/widgets/roller/lv_example_roller_1.c
C_SRCS += lvgl/examples/widgets/roller/lv_example_roller_2.c
C_SRCS += lvgl/examples/widgets/roller/lv_example_roller_3.c
C_SRCS += lvgl/examples/widgets/scale/lv_example_scale_1.c
C_SRCS += lvgl/examples/widgets/scale/lv_example_scale_10.c
C_SRCS += lvgl/examples/widgets/scale/lv_example_scale_11.c
C_SRCS += lvgl/examples/widgets/scale/lv_example_scale_12.c
C_SRCS += lvgl/examples/widgets/scale/lv_example_scale_2.c
C_SRCS += lvgl/examples/widgets/scale/lv_example_scale_3.c
C_SRCS += lvgl/examples/widgets/scale/lv_example_scale_4.c
C_SRCS += lvgl/examples/widgets/scale/lv_example_scale_5.c
C_SRCS += lvgl/examples/widgets/scale/lv_example_scale_6.c
C_SRCS += lvgl/examples/widgets/scale/lv_example_scale_7.c
C_SRCS += lvgl/examples/widgets/scale/lv_example_scale_8.c
C_SRCS += lvgl/examples/widgets/scale/lv_example_scale_9.c
C_SRCS += lvgl/examples/widgets/slider/lv_example_slider_1.c
C_SRCS += lvgl/examples/widgets/slider/lv_example_slider_2.c
C_SRCS += lvgl/examples/widgets/slider/lv_example_slider_3.c
C_SRCS += lvgl/examples/widgets/slider/lv_example_slider_4.c
C_SRCS += lvgl/examples/widgets/span/lv_example_span_1.c
C_SRCS += lvgl/examples/widgets/spinbox/lv_example_spinbox_1.c
C_SRCS += lvgl/examples/widgets/spinner/lv_example_spinner_1.c
C_SRCS += lvgl/examples/widgets/switch/lv_example_switch_1.c
C_SRCS += lvgl/examples/widgets/switch/lv_example_switch_2.c
C_SRCS += lvgl/examples/widgets/table/lv_example_table_1.c
C_SRCS += lvgl/examples/widgets/table/lv_example_table_2.c
C_SRCS += lvgl/examples/widgets/tabview/lv_example_tabview_1.c
C_SRCS += lvgl/examples/widgets/tabview/lv_example_tabview_2.c
C_SRCS += lvgl/examples/widgets/textarea/lv_example_textarea_1.c
C_SRCS += lvgl/examples/widgets/textarea/lv_example_textarea_2.c
C_SRCS += lvgl/examples/widgets/textarea/lv_example_textarea_3.c
C_SRCS += lvgl/examples/widgets/textarea/lv_example_textarea_4.c
C_SRCS += lvgl/examples/widgets/tileview/lv_example_tileview_1.c
C_SRCS += lvgl/examples/widgets/win/lv_example_win_1.c
C_SRCS += lvgl/src/core/lv_group.c
C_SRCS += lvgl/src/core/lv_obj.c
C_SRCS += lvgl/src/core/lv_obj_class.c
C_SRCS += lvgl/src/core/lv_obj_draw.c
C_SRCS += lvgl/src/core/lv_obj_event.c
C_SRCS += lvgl/src/core/lv_obj_id_builtin.c
C_SRCS += lvgl/src/core/lv_obj_pos.c
C_SRCS += lvgl/src/core/lv_obj_property.c
C_SRCS += lvgl/src/core/lv_obj_scroll.c
C_SRCS += lvgl/src/core/lv_obj_style.c
C_SRCS += lvgl/src/core/lv_obj_style_gen.c
C_SRCS += lvgl/src/core/lv_obj_tree.c
C_SRCS += lvgl/src/core/lv_refr.c
C_SRCS += lvgl/src/display/lv_display.c
C_SRCS += lvgl/src/draw/convert/helium/lv_draw_buf_convert_helium.c
C_SRCS += lvgl/src/draw/convert/lv_draw_buf_convert.c
C_SRCS += lvgl/src/draw/convert/neon/lv_draw_buf_convert_neon.c
C_SRCS += lvgl/src/draw/dma2d/lv_draw_dma2d.c
C_SRCS += lvgl/src/draw/dma2d/lv_draw_dma2d_fill.c
C_SRCS += lvgl/src/draw/dma2d/lv_draw_dma2d_img.c
C_SRCS += lvgl/src/draw/espressif/ppa/lv_draw_ppa.c
C_SRCS += lvgl/src/draw/espressif/ppa/lv_draw_ppa_buf.c
C_SRCS += lvgl/src/draw/espressif/ppa/lv_draw_ppa_fill.c
C_SRCS += lvgl/src/draw/espressif/ppa/lv_draw_ppa_img.c
C_SRCS += lvgl/src/draw/eve/lv_draw_eve.c
C_SRCS += lvgl/src/draw/eve/lv_draw_eve_arc.c
C_SRCS += lvgl/src/draw/eve/lv_draw_eve_fill.c
C_SRCS += lvgl/src/draw/eve/lv_draw_eve_image.c
C_SRCS += lvgl/src/draw/eve/lv_draw_eve_letter.c
C_SRCS += lvgl/src/draw/eve/lv_draw_eve_line.c
C_SRCS += lvgl/src/draw/eve/lv_draw_eve_ram_g.c
C_SRCS += lvgl/src/draw/eve/lv_draw_eve_triangle.c
C_SRCS += lvgl/src/draw/eve/lv_eve.c
C_SRCS += lvgl/src/draw/lv_draw.c
C_SRCS += lvgl/src/draw/lv_draw_3d.c
C_SRCS += lvgl/src/draw/lv_draw_arc.c
C_SRCS += lvgl/src/draw/lv_draw_buf.c
C_SRCS += lvgl/src/draw/lv_draw_image.c
C_SRCS += lvgl/src/draw/lv_draw_label.c
C_SRCS += lvgl/src/draw/lv_draw_line.c
C_SRCS += lvgl/src/draw/lv_draw_mask.c
C_SRCS += lvgl/src/draw/lv_draw_rect.c
C_SRCS += lvgl/src/draw/lv_draw_triangle.c
C_SRCS += lvgl/src/draw/lv_draw_vector.c
C_SRCS += lvgl/src/draw/lv_image_decoder.c
C_SRCS += lvgl/src/draw/nema_gfx/lv_draw_nema_gfx.c
C_SRCS += lvgl/src/draw/nema_gfx/lv_draw_nema_gfx_arc.c
C_SRCS += lvgl/src/draw/nema_gfx/lv_draw_nema_gfx_border.c
C_SRCS += lvgl/src/draw/nema_gfx/lv_draw_nema_gfx_fill.c
C_SRCS += lvgl/src/draw/nema_gfx/lv_draw_nema_gfx_img.c
C_SRCS += lvgl/src/draw/nema_gfx/lv_draw_nema_gfx_label.c
C_SRCS += lvgl/src/draw/nema_gfx/lv_draw_nema_gfx_layer.c
C_SRCS += lvgl/src/draw/nema_gfx/lv_draw_nema_gfx_line.c
C_SRCS += lvgl/src/draw/nema_gfx/lv_draw_nema_gfx_stm32_hal.c
C_SRCS += lvgl/src/draw/nema_gfx/lv_draw_nema_gfx_triangle.c
C_SRCS += lvgl/src/draw/nema_gfx/lv_draw_nema_gfx_utils.c
C_SRCS += lvgl/src/draw/nema_gfx/lv_draw_nema_gfx_vector.c
C_SRCS += lvgl/src/draw/nema_gfx/lv_nema_gfx_path.c
C_SRCS += lvgl/src/draw/nxp/g2d/lv_draw_buf_g2d.c
C_SRCS += lvgl/src/draw/nxp/g2d/lv_draw_g2d.c
C_SRCS += lvgl/src/draw/nxp/g2d/lv_draw_g2d_fill.c
C_SRCS += lvgl/src/draw/nxp/g2d/lv_draw_g2d_img.c
C_SRCS += lvgl/src/draw/nxp/g2d/lv_g2d_buf_map.c
C_SRCS += lvgl/src/draw/nxp/g2d/lv_g2d_utils.c
C_SRCS += lvgl/src/draw/nxp/pxp/lv_draw_buf_pxp.c
C_SRCS += lvgl/src/draw/nxp/pxp/lv_draw_pxp.c
C_SRCS += lvgl/src/draw/nxp/pxp/lv_draw_pxp_fill.c
C_SRCS += lvgl/src/draw/nxp/pxp/lv_draw_pxp_img.c
C_SRCS += lvgl/src/draw/nxp/pxp/lv_draw_pxp_layer.c
C_SRCS += lvgl/src/draw/nxp/pxp/lv_pxp_cfg.c
C_SRCS += lvgl/src/draw/nxp/pxp/lv_pxp_osa.c
C_SRCS += lvgl/src/draw/nxp/pxp/lv_pxp_utils.c
C_SRCS += lvgl/src/draw/opengles/lv_draw_opengles.c
C_SRCS += lvgl/src/draw/renesas/dave2d/lv_draw_dave2d.c
C_SRCS += lvgl/src/draw/renesas/dave2d/lv_draw_dave2d_arc.c
C_SRCS += lvgl/src/draw/renesas/dave2d/lv_draw_dave2d_border.c
C_SRCS += lvgl/src/draw/renesas/dave2d/lv_draw_dave2d_fill.c
C_SRCS += lvgl/src/draw/renesas/dave2d/lv_draw_dave2d_image.c
C_SRCS += lvgl/src/draw/renesas/dave2d/lv_draw_dave2d_label.c
C_SRCS += lvgl/src/draw/renesas/dave2d/lv_draw_dave2d_line.c
C_SRCS += lvgl/src/draw/renesas/dave2d/lv_draw_dave2d_mask_rectangle.c
C_SRCS += lvgl/src/draw/renesas/dave2d/lv_draw_dave2d_triangle.c
C_SRCS += lvgl/src/draw/renesas/dave2d/lv_draw_dave2d_utils.c
C_SRCS += lvgl/src/draw/sdl/lv_draw_sdl.c
C_SRCS += lvgl/src/draw/sw/blend/lv_draw_sw_blend.c
C_SRCS += lvgl/src/draw/sw/blend/lv_draw_sw_blend_to_al88.c
C_SRCS += lvgl/src/draw/sw/blend/lv_draw_sw_blend_to_argb8888.c
C_SRCS += lvgl/src/draw/sw/blend/lv_draw_sw_blend_to_argb8888_premultiplied.c
C_SRCS += lvgl/src/draw/sw/blend/lv_draw_sw_blend_to_i1.c
C_SRCS += lvgl/src/draw/sw/blend/lv_draw_sw_blend_to_l8.c
C_SRCS += lvgl/src/draw/sw/blend/lv_draw_sw_blend_to_rgb565.c
C_SRCS += lvgl/src/draw/sw/blend/lv_draw_sw_blend_to_rgb565_swapped.c
C_SRCS += lvgl/src/draw/sw/blend/lv_draw_sw_blend_to_rgb888.c
C_SRCS += lvgl/src/draw/sw/blend/neon/lv_draw_sw_blend_neon_to_rgb565.c
C_SRCS += lvgl/src/draw/sw/blend/neon/lv_draw_sw_blend_neon_to_rgb888.c
C_SRCS += lvgl/src/draw/sw/lv_draw_sw.c
C_SRCS += lvgl/src/draw/sw/lv_draw_sw_arc.c
C_SRCS += lvgl/src/draw/sw/lv_draw_sw_border.c
C_SRCS += lvgl/src/draw/sw/lv_draw_sw_box_shadow.c
C_SRCS += lvgl/src/draw/sw/lv_draw_sw_fill.c
C_SRCS += lvgl/src/draw/sw/lv_draw_sw_grad.c
C_SRCS += lvgl/src/draw/sw/lv_draw_sw_img.c
C_SRCS += lvgl/src/draw/sw/lv_draw_sw_letter.c
C_SRCS += lvgl/src/draw/sw/lv_draw_sw_line.c
C_SRCS += lvgl/src/draw/sw/lv_draw_sw_mask.c
C_SRCS += lvgl/src/draw/sw/lv_draw_sw_mask_rect.c
C_SRCS += lvgl/src/draw/sw/lv_draw_sw_transform.c
C_SRCS += lvgl/src/draw/sw/lv_draw_sw_triangle.c
C_SRCS += lvgl/src/draw/sw/lv_draw_sw_utils.c
C_SRCS += lvgl/src/draw/sw/lv_draw_sw_vector.c
C_SRCS += lvgl/src/draw/vg_lite/lv_draw_buf_vg_lite.c
C_SRCS += lvgl/src/draw/vg_lite/lv_draw_vg_lite.c
C_SRCS += lvgl/src/draw/vg_lite/lv_draw_vg_lite_arc.c
C_SRCS += lvgl/src/draw/vg_lite/lv_draw_vg_lite_border.c
C_SRCS += lvgl/src/draw/vg_lite/lv_draw_vg_lite_box_shadow.c
C_SRCS += lvgl/src/draw/vg_lite/lv_draw_vg_lite_fill.c
C_SRCS += lvgl/src/draw/vg_lite/lv_draw_vg_lite_img.c
C_SRCS += lvgl/src/draw/vg_lite/lv_draw_vg_lite_label.c
C_SRCS += lvgl/src/draw/vg_lite/lv_draw_vg_lite_layer.c
C_SRCS += lvgl/src/draw/vg_lite/lv_draw_vg_lite_line.c
C_SRCS += lvgl/src/draw/vg_lite/lv_draw_vg_lite_mask_rect.c
C_SRCS += lvgl/src/draw/vg_lite/lv_draw_vg_lite_triangle.c
C_SRCS += lvgl/src/draw/vg_lite/lv_draw_vg_lite_vector.c
C_SRCS += lvgl/src/draw/vg_lite/lv_vg_lite_decoder.c
C_SRCS += lvgl/src/draw/vg_lite/lv_vg_lite_grad.c
C_SRCS += lvgl/src/draw/vg_lite/lv_vg_lite_math.c
C_SRCS += lvgl/src/draw/vg_lite/lv_vg_lite_path.c
C_SRCS += lvgl/src/draw/vg_lite/lv_vg_lite_pending.c
C_SRCS += lvgl/src/draw/vg_lite/lv_vg_lite_stroke.c
C_SRCS += lvgl/src/draw/vg_lite/lv_vg_lite_utils.c
C_SRCS += lvgl/src/drivers/display/drm/lv_linux_drm.c
C_SRCS += lvgl/src/drivers/display/drm/lv_linux_drm_common.c
C_SRCS += lvgl/src/drivers/display/drm/lv_linux_drm_egl.c
C_SRCS += lvgl/src/drivers/display/fb/lv_linux_fbdev.c
C_SRCS += lvgl/src/drivers/display/ft81x/lv_ft81x.c
C_SRCS += lvgl/src/drivers/display/ili9341/lv_ili9341.c
C_SRCS += lvgl/src/drivers/display/lcd/lv_lcd_generic_mipi.c
C_SRCS += lvgl/src/drivers/display/nv3007/lv_nv3007.c
C_SRCS += lvgl/src/drivers/display/nxp_elcdif/lv_nxp_elcdif.c
C_SRCS += lvgl/src/drivers/display/renesas_glcdc/lv_renesas_glcdc.c
C_SRCS += lvgl/src/drivers/display/st7735/lv_st7735.c
C_SRCS += lvgl/src/drivers/display/st7789/lv_st7789.c
C_SRCS += lvgl/src/drivers/display/st7796/lv_st7796.c
C_SRCS += lvgl/src/drivers/display/st_ltdc/lv_st_ltdc.c
C_SRCS += lvgl/src/drivers/draw/eve/lv_draw_eve_display.c
C_SRCS += lvgl/src/drivers/evdev/lv_evdev.c
C_SRCS += lvgl/src/drivers/libinput/lv_libinput.c
C_SRCS += lvgl/src/drivers/libinput/lv_xkb.c
C_SRCS += lvgl/src/drivers/nuttx/lv_nuttx_cache.c
C_SRCS += lvgl/src/drivers/nuttx/lv_nuttx_entry.c
C_SRCS += lvgl/src/drivers/nuttx/lv_nuttx_fbdev.c
C_SRCS += lvgl/src/drivers/nuttx/lv_nuttx_image_cache.c
C_SRCS += lvgl/src/drivers/nuttx/lv_nuttx_lcd.c
C_SRCS += lvgl/src/drivers/nuttx/lv_nuttx_libuv.c
C_SRCS += lvgl/src/drivers/nuttx/lv_nuttx_mouse.c
C_SRCS += lvgl/src/drivers/nuttx/lv_nuttx_profiler.c
C_SRCS += lvgl/src/drivers/nuttx/lv_nuttx_touchscreen.c
C_SRCS += lvgl/src/drivers/opengles/assets/lv_opengles_shader.c
C_SRCS += lvgl/src/drivers/opengles/glad/src/egl.c
C_SRCS += lvgl/src/drivers/opengles/glad/src/gles2.c
C_SRCS += lvgl/src/drivers/opengles/lv_opengles_debug.c
C_SRCS += lvgl/src/drivers/opengles/lv_opengles_driver.c
C_SRCS += lvgl/src/drivers/opengles/lv_opengles_egl.c
C_SRCS += lvgl/src/drivers/opengles/lv_opengles_glfw.c
C_SRCS += lvgl/src/drivers/opengles/lv_opengles_texture.c
C_SRCS += lvgl/src/drivers/opengles/opengl_shader/lv_opengl_shader_manager.c
C_SRCS += lvgl/src/drivers/opengles/opengl_shader/lv_opengl_shader_program.c
C_SRCS += lvgl/src/drivers/qnx/lv_qnx.c
C_SRCS += lvgl/src/drivers/sdl/lv_sdl_keyboard.c
C_SRCS += lvgl/src/drivers/sdl/lv_sdl_mouse.c
C_SRCS += lvgl/src/drivers/sdl/lv_sdl_mousewheel.c
C_SRCS += lvgl/src/drivers/sdl/lv_sdl_window.c
C_SRCS += lvgl/src/drivers/uefi/lv_uefi_context.c
C_SRCS += lvgl/src/drivers/uefi/lv_uefi_display.c
C_SRCS += lvgl/src/drivers/uefi/lv_uefi_indev_keyboard.c
C_SRCS += lvgl/src/drivers/uefi/lv_uefi_indev_pointer.c
C_SRCS += lvgl/src/drivers/uefi/lv_uefi_indev_touch.c
C_SRCS += lvgl/src/drivers/uefi/lv_uefi_private.c
C_SRCS += lvgl/src/drivers/wayland/lv_wayland.c
C_SRCS += lvgl/src/drivers/wayland/lv_wayland_smm.c
C_SRCS += lvgl/src/drivers/wayland/lv_wl_cache.c
C_SRCS += lvgl/src/drivers/wayland/lv_wl_dmabuf.c
C_SRCS += lvgl/src/drivers/wayland/lv_wl_keyboard.c
C_SRCS += lvgl/src/drivers/wayland/lv_wl_pointer.c
C_SRCS += lvgl/src/drivers/wayland/lv_wl_pointer_axis.c
C_SRCS += lvgl/src/drivers/wayland/lv_wl_seat.c
C_SRCS += lvgl/src/drivers/wayland/lv_wl_shm.c
C_SRCS += lvgl/src/drivers/wayland/lv_wl_touch.c
C_SRCS += lvgl/src/drivers/wayland/lv_wl_window.c
C_SRCS += lvgl/src/drivers/wayland/lv_wl_window_decorations.c
C_SRCS += lvgl/src/drivers/wayland/lv_wl_xdg_shell.c
C_SRCS += lvgl/src/drivers/windows/lv_windows_context.c
C_SRCS += lvgl/src/drivers/windows/lv_windows_display.c
C_SRCS += lvgl/src/drivers/windows/lv_windows_input.c
C_SRCS += lvgl/src/drivers/x11/lv_x11_display.c
C_SRCS += lvgl/src/drivers/x11/lv_x11_input.c
C_SRCS += lvgl/src/font/lv_binfont_loader.c
C_SRCS += lvgl/src/font/lv_font.c
C_SRCS += lvgl/src/font/lv_font_dejavu_16_persian_hebrew.c
C_SRCS += lvgl/src/font/lv_font_fmt_txt.c
C_SRCS += lvgl/src/font/lv_font_montserrat_10.c
C_SRCS += lvgl/src/font/lv_font_montserrat_12.c
C_SRCS += lvgl/src/font/lv_font_montserrat_14.c
C_SRCS += lvgl/src/font/lv_font_montserrat_14_aligned.c
C_SRCS += lvgl/src/font/lv_font_montserrat_16.c
C_SRCS += lvgl/src/font/lv_font_montserrat_18.c
C_SRCS += lvgl/src/font/lv_font_montserrat_20.c
C_SRCS += lvgl/src/font/lv_font_montserrat_22.c
C_SRCS += lvgl/src/font/lv_font_montserrat_24.c
C_SRCS += lvgl/src/font/lv_font_montserrat_26.c
C_SRCS += lvgl/src/font/lv_font_montserrat_28.c
C_SRCS += lvgl/src/font/lv_font_montserrat_28_compressed.c
C_SRCS += lvgl/src/font/lv_font_montserrat_30.c
C_SRCS += lvgl/src/font/lv_font_montserrat_32.c
C_SRCS += lvgl/src/font/lv_font_montserrat_34.c
C_SRCS += lvgl/src/font/lv_font_montserrat_36.c
C_SRCS += lvgl/src/font/lv_font_montserrat_38.c
C_SRCS += lvgl/src/font/lv_font_montserrat_40.c
C_SRCS += lvgl/src/font/lv_font_montserrat_42.c
C_SRCS += lvgl/src/font/lv_font_montserrat_44.c
C_SRCS += lvgl/src/font/lv_font_montserrat_46.c
C_SRCS += lvgl/src/font/lv_font_montserrat_48.c
C_SRCS += lvgl/src/font/lv_font_montserrat_8.c
C_SRCS += lvgl/src/font/lv_font_source_han_sans_sc_14_cjk.c
C_SRCS += lvgl/src/font/lv_font_source_han_sans_sc_16_cjk.c
C_SRCS += lvgl/src/font/lv_font_unscii_16.c
C_SRCS += lvgl/src/font/lv_font_unscii_8.c
C_SRCS += lvgl/src/indev/lv_indev.c
C_SRCS += lvgl/src/indev/lv_indev_gesture.c
C_SRCS += lvgl/src/indev/lv_indev_scroll.c
C_SRCS += lvgl/src/layouts/flex/lv_flex.c
C_SRCS += lvgl/src/layouts/grid/lv_grid.c
C_SRCS += lvgl/src/layouts/lv_layout.c
C_SRCS += lvgl/src/libs/FT800-FT813/EVE_commands.c
C_SRCS += lvgl/src/libs/FT800-FT813/EVE_supplemental.c
C_SRCS += lvgl/src/libs/barcode/code128.c
C_SRCS += lvgl/src/libs/barcode/lv_barcode.c
C_SRCS += lvgl/src/libs/bin_decoder/lv_bin_decoder.c
C_SRCS += lvgl/src/libs/bmp/lv_bmp.c
C_SRCS += lvgl/src/libs/expat/xmlparse.c
C_SRCS += lvgl/src/libs/expat/xmlrole.c
C_SRCS += lvgl/src/libs/expat/xmltok.c
C_SRCS += lvgl/src/libs/expat/xmltok_impl.c
C_SRCS += lvgl/src/libs/expat/xmltok_ns.c
C_SRCS += lvgl/src/libs/ffmpeg/lv_ffmpeg.c
C_SRCS += lvgl/src/libs/freetype/lv_freetype.c
C_SRCS += lvgl/src/libs/freetype/lv_freetype_glyph.c
C_SRCS += lvgl/src/libs/freetype/lv_freetype_image.c
C_SRCS += lvgl/src/libs/freetype/lv_freetype_outline.c
C_SRCS += lvgl/src/libs/freetype/lv_ftsystem.c
C_SRCS += lvgl/src/libs/frogfs/src/decomp_raw.c
C_SRCS += lvgl/src/libs/frogfs/src/frogfs.c
C_SRCS += lvgl/src/libs/fsdrv/lv_fs_cbfs.c
C_SRCS += lvgl/src/libs/fsdrv/lv_fs_fatfs.c
C_SRCS += lvgl/src/libs/fsdrv/lv_fs_frogfs.c
C_SRCS += lvgl/src/libs/fsdrv/lv_fs_littlefs.c
C_SRCS += lvgl/src/libs/fsdrv/lv_fs_memfs.c
C_SRCS += lvgl/src/libs/fsdrv/lv_fs_posix.c
C_SRCS += lvgl/src/libs/fsdrv/lv_fs_stdio.c
C_SRCS += lvgl/src/libs/fsdrv/lv_fs_uefi.c
C_SRCS += lvgl/src/libs/fsdrv/lv_fs_win32.c
C_SRCS += lvgl/src/libs/gif/AnimatedGIF/src/gif.c
C_SRCS += lvgl/src/libs/gif/lv_gif.c
C_SRCS += lvgl/src/libs/gltf/gltf_view/assets/chromatic.c
C_SRCS += lvgl/src/libs/gltf/gltf_view/assets/lv_gltf_view_shader.c
C_SRCS += lvgl/src/libs/gltf/gltf_view/ibl/lv_gltf_ibl_sampler.c
C_SRCS += lvgl/src/libs/gstreamer/lv_gstreamer.c
C_SRCS += lvgl/src/libs/libjpeg_turbo/lv_libjpeg_turbo.c
C_SRCS += lvgl/src/libs/libpng/lv_libpng.c
C_SRCS += lvgl/src/libs/lodepng/lodepng.c
C_SRCS += lvgl/src/libs/lodepng/lv_lodepng.c
C_SRCS += lvgl/src/libs/lz4/lz4.c
C_SRCS += lvgl/src/libs/qrcode/lv_qrcode.c
C_SRCS += lvgl/src/libs/qrcode/qrcodegen.c
C_SRCS += lvgl/src/libs/rle/lv_rle.c
C_SRCS += lvgl/src/libs/rlottie/lv_rlottie.c
C_SRCS += lvgl/src/libs/svg/lv_svg.c
C_SRCS += lvgl/src/libs/svg/lv_svg_decoder.c
C_SRCS += lvgl/src/libs/svg/lv_svg_parser.c
C_SRCS += lvgl/src/libs/svg/lv_svg_render.c
C_SRCS += lvgl/src/libs/svg/lv_svg_token.c
C_SRCS += lvgl/src/libs/tiny_ttf/lv_tiny_ttf.c
C_SRCS += lvgl/src/libs/tjpgd/lv_tjpgd.c
C_SRCS += lvgl/src/libs/tjpgd/tjpgd.c
C_SRCS += lvgl/src/libs/vg_lite_driver/VGLite/vg_lite.c
C_SRCS += lvgl/src/libs/vg_lite_driver/VGLite/vg_lite_image.c
C_SRCS += lvgl/src/libs/vg_lite_driver/VGLite/vg_lite_matrix.c
C_SRCS += lvgl/src/libs/vg_lite_driver/VGLite/vg_lite_path.c
C_SRCS += lvgl/src/libs/vg_lite_driver/VGLite/vg_lite_stroke.c
C_SRCS += lvgl/src/libs/vg_lite_driver/VGLiteKernel/vg_lite_kernel.c
C_SRCS += lvgl/src/libs/vg_lite_driver/lv_vg_lite_hal/lv_vg_lite_hal.c
C_SRCS += lvgl/src/libs/vg_lite_driver/lv_vg_lite_hal/vg_lite_os.c
C_SRCS += lvgl/src/lv_init.c
C_SRCS += lvgl/src/misc/cache/class/lv_cache_lru_ll.c
C_SRCS += lvgl/src/misc/cache/class/lv_cache_lru_rb.c
C_SRCS += lvgl/src/misc/cache/class/lv_cache_sc_da.c
C_SRCS += lvgl/src/misc/cache/instance/lv_image_cache.c
C_SRCS += lvgl/src/misc/cache/instance/lv_image_header_cache.c
C_SRCS += lvgl/src/misc/cache/lv_cache.c
C_SRCS += lvgl/src/misc/cache/lv_cache_entry.c
C_SRCS += lvgl/src/misc/lv_anim.c
C_SRCS += lvgl/src/misc/lv_anim_timeline.c
C_SRCS += lvgl/src/misc/lv_area.c
C_SRCS += lvgl/src/misc/lv_array.c
C_SRCS += lvgl/src/misc/lv_async.c
C_SRCS += lvgl/src/misc/lv_bidi.c
C_SRCS += lvgl/src/misc/lv_circle_buf.c
C_SRCS += lvgl/src/misc/lv_color.c
C_SRCS += lvgl/src/misc/lv_color_op.c
C_SRCS += lvgl/src/misc/lv_event.c
C_SRCS += lvgl/src/misc/lv_fs.c
C_SRCS += lvgl/src/misc/lv_grad.c
C_SRCS += lvgl/src/misc/lv_iter.c
C_SRCS += lvgl/src/misc/lv_ll.c
C_SRCS += lvgl/src/misc/lv_log.c
C_SRCS += lvgl/src/misc/lv_lru.c
C_SRCS += lvgl/src/misc/lv_math.c
C_SRCS += lvgl/src/misc/lv_matrix.c
C_SRCS += lvgl/src/misc/lv_palette.c
C_SRCS += lvgl/src/misc/lv_profiler_builtin.c
C_SRCS += lvgl/src/misc/lv_profiler_builtin_posix.c
C_SRCS += lvgl/src/misc/lv_rb.c
C_SRCS += lvgl/src/misc/lv_style.c
C_SRCS += lvgl/src/misc/lv_style_gen.c
C_SRCS += lvgl/src/misc/lv_templ.c
C_SRCS += lvgl/src/misc/lv_text.c
C_SRCS += lvgl/src/misc/lv_text_ap.c
C_SRCS += lvgl/src/misc/lv_timer.c
C_SRCS += lvgl/src/misc/lv_tree.c
C_SRCS += lvgl/src/misc/lv_utils.c
C_SRCS += lvgl/src/osal/lv_cmsis_rtos2.c
C_SRCS += lvgl/src/osal/lv_freertos.c
C_SRCS += lvgl/src/osal/lv_linux.c
C_SRCS += lvgl/src/osal/lv_mqx.c
C_SRCS += lvgl/src/osal/lv_os.c
C_SRCS += lvgl/src/osal/lv_os_none.c
C_SRCS += lvgl/src/osal/lv_pthread.c
C_SRCS += lvgl/src/osal/lv_rtthread.c
C_SRCS += lvgl/src/osal/lv_sdl2.c
C_SRCS += lvgl/src/osal/lv_windows.c
C_SRCS += lvgl/src/others/file_explorer/lv_file_explorer.c
C_SRCS += lvgl/src/others/font_manager/lv_font_manager.c
C_SRCS += lvgl/src/others/font_manager/lv_font_manager_recycle.c
C_SRCS += lvgl/src/others/fragment/lv_fragment.c
C_SRCS += lvgl/src/others/fragment/lv_fragment_manager.c
C_SRCS += lvgl/src/others/gridnav/lv_gridnav.c
C_SRCS += lvgl/src/others/ime/lv_ime_pinyin.c
C_SRCS += lvgl/src/others/imgfont/lv_imgfont.c
C_SRCS += lvgl/src/others/monkey/lv_monkey.c
C_SRCS += lvgl/src/others/observer/lv_observer.c
C_SRCS += lvgl/src/others/snapshot/lv_snapshot.c
C_SRCS += lvgl/src/others/sysmon/lv_sysmon.c
C_SRCS += lvgl/src/others/test/lv_test_display.c
C_SRCS += lvgl/src/others/test/lv_test_helpers.c
C_SRCS += lvgl/src/others/test/lv_test_indev.c
C_SRCS += lvgl/src/others/test/lv_test_indev_gesture.c
C_SRCS += lvgl/src/others/test/lv_test_screenshot_compare.c
C_SRCS += lvgl/src/others/translation/lv_translation.c
C_SRCS += lvgl/src/others/vg_lite_tvg/vg_lite_matrix.c
C_SRCS += lvgl/src/others/xml/lv_xml.c
C_SRCS += lvgl/src/others/xml/lv_xml_base_types.c
C_SRCS += lvgl/src/others/xml/lv_xml_component.c
C_SRCS += lvgl/src/others/xml/lv_xml_load.c
C_SRCS += lvgl/src/others/xml/lv_xml_parser.c
C_SRCS += lvgl/src/others/xml/lv_xml_style.c
C_SRCS += lvgl/src/others/xml/lv_xml_test.c
C_SRCS += lvgl/src/others/xml/lv_xml_translation.c
C_SRCS += lvgl/src/others/xml/lv_xml_update.c
C_SRCS += lvgl/src/others/xml/lv_xml_utils.c
C_SRCS += lvgl/src/others/xml/lv_xml_widget.c
C_SRCS += lvgl/src/others/xml/parsers/lv_xml_arc_parser.c
C_SRCS += lvgl/src/others/xml/parsers/lv_xml_bar_parser.c
C_SRCS += lvgl/src/others/xml/parsers/lv_xml_button_parser.c
C_SRCS += lvgl/src/others/xml/parsers/lv_xml_buttonmatrix_parser.c
C_SRCS += lvgl/src/others/xml/parsers/lv_xml_calendar_parser.c
C_SRCS += lvgl/src/others/xml/parsers/lv_xml_canvas_parser.c
C_SRCS += lvgl/src/others/xml/parsers/lv_xml_chart_parser.c
C_SRCS += lvgl/src/others/xml/parsers/lv_xml_checkbox_parser.c
C_SRCS += lvgl/src/others/xml/parsers/lv_xml_dropdown_parser.c
C_SRCS += lvgl/src/others/xml/parsers/lv_xml_image_parser.c
C_SRCS += lvgl/src/others/xml/parsers/lv_xml_keyboard_parser.c
C_SRCS += lvgl/src/others/xml/parsers/lv_xml_label_parser.c
C_SRCS += lvgl/src/others/xml/parsers/lv_xml_obj_parser.c
C_SRCS += lvgl/src/others/xml/parsers/lv_xml_qrcode_parser.c
C_SRCS += lvgl/src/others/xml/parsers/lv_xml_roller_parser.c
C_SRCS += lvgl/src/others/xml/parsers/lv_xml_scale_parser.c
C_SRCS += lvgl/src/others/xml/parsers/lv_xml_slider_parser.c
C_SRCS += lvgl/src/others/xml/parsers/lv_xml_spangroup_parser.c
C_SRCS += lvgl/src/others/xml/parsers/lv_xml_spinbox_parser.c
C_SRCS += lvgl/src/others/xml/parsers/lv_xml_switch_parser.c
C_SRCS += lvgl/src/others/xml/parsers/lv_xml_table_parser.c
C_SRCS += lvgl/src/others/xml/parsers/lv_xml_tabview_parser.c
C_SRCS += lvgl/src/others/xml/parsers/lv_xml_textarea_parser.c
C_SRCS += lvgl/src/stdlib/builtin/lv_mem_core_builtin.c
C_SRCS += lvgl/src/stdlib/builtin/lv_sprintf_builtin.c
C_SRCS += lvgl/src/stdlib/builtin/lv_string_builtin.c
C_SRCS += lvgl/src/stdlib/builtin/lv_tlsf.c
C_SRCS += lvgl/src/stdlib/clib/lv_mem_core_clib.c
C_SRCS += lvgl/src/stdlib/clib/lv_sprintf_clib.c
C_SRCS += lvgl/src/stdlib/clib/lv_string_clib.c
C_SRCS += lvgl/src/stdlib/lv_mem.c
C_SRCS += lvgl/src/stdlib/micropython/lv_mem_core_micropython.c
C_SRCS += lvgl/src/stdlib/rtthread/lv_mem_core_rtthread.c
C_SRCS += lvgl/src/stdlib/rtthread/lv_sprintf_rtthread.c
C_SRCS += lvgl/src/stdlib/rtthread/lv_string_rtthread.c
C_SRCS += lvgl/src/stdlib/uefi/lv_mem_core_uefi.c
C_SRCS += lvgl/src/themes/default/lv_theme_default.c
C_SRCS += lvgl/src/themes/lv_theme.c
C_SRCS += lvgl/src/themes/mono/lv_theme_mono.c
C_SRCS += lvgl/src/themes/simple/lv_theme_simple.c
C_SRCS += lvgl/src/tick/lv_tick.c
C_SRCS += lvgl/src/widgets/3dtexture/lv_3dtexture.c
C_SRCS += lvgl/src/widgets/animimage/lv_animimage.c
C_SRCS += lvgl/src/widgets/arc/lv_arc.c
C_SRCS += lvgl/src/widgets/arclabel/lv_arclabel.c
C_SRCS += lvgl/src/widgets/bar/lv_bar.c
C_SRCS += lvgl/src/widgets/button/lv_button.c
C_SRCS += lvgl/src/widgets/buttonmatrix/lv_buttonmatrix.c
C_SRCS += lvgl/src/widgets/calendar/lv_calendar.c
C_SRCS += lvgl/src/widgets/calendar/lv_calendar_chinese.c
C_SRCS += lvgl/src/widgets/calendar/lv_calendar_header_arrow.c
C_SRCS += lvgl/src/widgets/calendar/lv_calendar_header_dropdown.c
C_SRCS += lvgl/src/widgets/canvas/lv_canvas.c
C_SRCS += lvgl/src/widgets/chart/lv_chart.c
C_SRCS += lvgl/src/widgets/checkbox/lv_checkbox.c
C_SRCS += lvgl/src/widgets/dropdown/lv_dropdown.c
C_SRCS += lvgl/src/widgets/image/lv_image.c
C_SRCS += lvgl/src/widgets/imagebutton/lv_imagebutton.c
C_SRCS += lvgl/src/widgets/keyboard/lv_keyboard.c
C_SRCS += lvgl/src/widgets/label/lv_label.c
C_SRCS += lvgl/src/widgets/led/lv_led.c
C_SRCS += lvgl/src/widgets/line/lv_line.c
C_SRCS += lvgl/src/widgets/list/lv_list.c
C_SRCS += lvgl/src/widgets/lottie/lv_lottie.c
C_SRCS += lvgl/src/widgets/menu/lv_menu.c
C_SRCS += lvgl/src/widgets/msgbox/lv_msgbox.c
C_SRCS += lvgl/src/widgets/objx_templ/lv_objx_templ.c
C_SRCS += lvgl/src/widgets/property/lv_animimage_properties.c
C_SRCS += lvgl/src/widgets/property/lv_dropdown_properties.c
C_SRCS += lvgl/src/widgets/property/lv_image_properties.c
C_SRCS += lvgl/src/widgets/property/lv_keyboard_properties.c
C_SRCS += lvgl/src/widgets/property/lv_label_properties.c
C_SRCS += lvgl/src/widgets/property/lv_obj_properties.c
C_SRCS += lvgl/src/widgets/property/lv_roller_properties.c
C_SRCS += lvgl/src/widgets/property/lv_slider_properties.c
C_SRCS += lvgl/src/widgets/property/lv_style_properties.c
C_SRCS += lvgl/src/widgets/property/lv_textarea_properties.c
C_SRCS += lvgl/src/widgets/roller/lv_roller.c
C_SRCS += lvgl/src/widgets/scale/lv_scale.c
C_SRCS += lvgl/src/widgets/slider/lv_slider.c
C_SRCS += lvgl/src/widgets/span/lv_span.c
C_SRCS += lvgl/src/widgets/spinbox/lv_spinbox.c
C_SRCS += lvgl/src/widgets/spinner/lv_spinner.c
C_SRCS += lvgl/src/widgets/switch/lv_switch.c
C_SRCS += lvgl/src/widgets/table/lv_table.c
C_SRCS += lvgl/src/widgets/tabview/lv_tabview.c
C_SRCS += lvgl/src/widgets/textarea/lv_textarea.c
C_SRCS += lvgl/src/widgets/tileview/lv_tileview.c
C_SRCS += lvgl/src/widgets/win/lv_win.c
C_SRCS += lvgl/tests/makefiles/test.c
C_SRCS += lvgl/tests/makefiles_uefi/test.c
C_SRCS += lvgl/tests/src/lv_test_init.c
C_SRCS += lvgl/tests/src/test_assets/test_animimg001.c
C_SRCS += lvgl/tests/src/test_assets/test_animimg002.c
C_SRCS += lvgl/tests/src/test_assets/test_animimg003.c
C_SRCS += lvgl/tests/src/test_assets/test_arc_bg.c
C_SRCS += lvgl/tests/src/test_assets/test_font_1.c
C_SRCS += lvgl/tests/src/test_assets/test_font_1_bin.c
C_SRCS += lvgl/tests/src/test_assets/test_font_2.c
C_SRCS += lvgl/tests/src/test_assets/test_font_2_bin.c
C_SRCS += lvgl/tests/src/test_assets/test_font_3.c
C_SRCS += lvgl/tests/src/test_assets/test_font_3_bin.c
C_SRCS += lvgl/tests/src/test_assets/test_font_montserrat_ascii_1bpp.c
C_SRCS += lvgl/tests/src/test_assets/test_font_montserrat_ascii_2bpp.c
C_SRCS += lvgl/tests/src/test_assets/test_font_montserrat_ascii_3bpp_compressed.c
C_SRCS += lvgl/tests/src/test_assets/test_font_montserrat_ascii_4bpp.c
C_SRCS += lvgl/tests/src/test_assets/test_font_montserrat_ascii_8bpp.c
C_SRCS += lvgl/tests/src/test_assets/test_imagebutton_left.c
C_SRCS += lvgl/tests/src/test_assets/test_imagebutton_mid.c
C_SRCS += lvgl/tests/src/test_assets/test_imagebutton_right.c
C_SRCS += lvgl/tests/src/test_assets/test_img_caret_down.c
C_SRCS += lvgl/tests/src/test_assets/test_img_cogwheel_a8.c
C_SRCS += lvgl/tests/src/test_assets/test_img_cogwheel_argb8888.c
C_SRCS += lvgl/tests/src/test_assets/test_img_cogwheel_i4.c
C_SRCS += lvgl/tests/src/test_assets/test_img_cogwheel_rgb565.c
C_SRCS += lvgl/tests/src/test_assets/test_img_cogwheel_rgb565a8.c
C_SRCS += lvgl/tests/src/test_assets/test_img_cogwheel_xrgb8888.c
C_SRCS += lvgl/tests/src/test_assets/test_img_emoji_F617.c
C_SRCS += lvgl/tests/src/test_assets/test_img_lvgl_logo_jpg.c
C_SRCS += lvgl/tests/src/test_assets/test_img_lvgl_logo_png.c
C_SRCS += lvgl/tests/src/test_assets/test_img_svg.c
C_SRCS += lvgl/tests/src/test_assets/test_kern_one_otf.c
C_SRCS += lvgl/tests/src/test_assets/test_lottie_approve.c
C_SRCS += lvgl/tests/src/test_assets/test_music_button_play.c
C_SRCS += lvgl/tests/src/test_assets/test_ubuntu_font.c
C_SRCS += lvgl/tests/src/test_cases/_test_template.c
C_SRCS += lvgl/tests/src/test_cases/cache/test_cache.c
C_SRCS += lvgl/tests/src/test_cases/draw/test_bg_image.c
C_SRCS += lvgl/tests/src/test_cases/draw/test_clip_corner.c
C_SRCS += lvgl/tests/src/test_cases/draw/test_draw_blend.c
C_SRCS += lvgl/tests/src/test_cases/draw/test_draw_custom_handlers.c
C_SRCS += lvgl/tests/src/test_cases/draw/test_draw_label.c
C_SRCS += lvgl/tests/src/test_cases/draw/test_draw_layer.c
C_SRCS += lvgl/tests/src/test_cases/draw/test_draw_letter.c
C_SRCS += lvgl/tests/src/test_cases/draw/test_draw_svg.c
C_SRCS += lvgl/tests/src/test_cases/draw/test_draw_sw_post_process.c
C_SRCS += lvgl/tests/src/test_cases/draw/test_draw_vector.c
C_SRCS += lvgl/tests/src/test_cases/draw/test_image_colorkey.c
C_SRCS += lvgl/tests/src/test_cases/draw/test_image_formats.c
C_SRCS += lvgl/tests/src/test_cases/draw/test_layer_transform.c
C_SRCS += lvgl/tests/src/test_cases/draw/test_render_to_al88.c
C_SRCS += lvgl/tests/src/test_cases/draw/test_render_to_argb1555.c
C_SRCS += lvgl/tests/src/test_cases/draw/test_render_to_argb2222.c
C_SRCS += lvgl/tests/src/test_cases/draw/test_render_to_argb4444.c
C_SRCS += lvgl/tests/src/test_cases/draw/test_render_to_argb8888.c
C_SRCS += lvgl/tests/src/test_cases/draw/test_render_to_argb8888_premultiplied.c
C_SRCS += lvgl/tests/src/test_cases/draw/test_render_to_i1.c
C_SRCS += lvgl/tests/src/test_cases/draw/test_render_to_l8.c
C_SRCS += lvgl/tests/src/test_cases/draw/test_render_to_rgb565.c
C_SRCS += lvgl/tests/src/test_cases/draw/test_render_to_rgb565_swapped.c
C_SRCS += lvgl/tests/src/test_cases/draw/test_render_to_rgb888.c
C_SRCS += lvgl/tests/src/test_cases/draw/test_render_to_xrgb8888.c
C_SRCS += lvgl/tests/src/test_cases/libs/test_barcode.c
C_SRCS += lvgl/tests/src/test_cases/libs/test_bin_decoder.c
C_SRCS += lvgl/tests/src/test_cases/libs/test_bmp.c
C_SRCS += lvgl/tests/src/test_cases/libs/test_ffmpeg.c
C_SRCS += lvgl/tests/src/test_cases/libs/test_font_stress.c
C_SRCS += lvgl/tests/src/test_cases/libs/test_freetype.c
C_SRCS += lvgl/tests/src/test_cases/libs/test_libjpeg_turbo.c
C_SRCS += lvgl/tests/src/test_cases/libs/test_libpng.c
C_SRCS += lvgl/tests/src/test_cases/libs/test_lodepng.c
C_SRCS += lvgl/tests/src/test_cases/libs/test_memmove.c
C_SRCS += lvgl/tests/src/test_cases/libs/test_qrcode.c
C_SRCS += lvgl/tests/src/test_cases/libs/test_svg_decoder.c
C_SRCS += lvgl/tests/src/test_cases/libs/test_tiny_ttf.c
C_SRCS += lvgl/tests/src/test_cases/libs/test_tjpgd.c
C_SRCS += lvgl/tests/src/test_cases/test_align_flex.c
C_SRCS += lvgl/tests/src/test_cases/test_anim.c
C_SRCS += lvgl/tests/src/test_cases/test_anim_timeline.c
C_SRCS += lvgl/tests/src/test_cases/test_area.c
C_SRCS += lvgl/tests/src/test_cases/test_array.c
C_SRCS += lvgl/tests/src/test_cases/test_bindings.c
C_SRCS += lvgl/tests/src/test_cases/test_circle_buf.c
C_SRCS += lvgl/tests/src/test_cases/test_click.c
C_SRCS += lvgl/tests/src/test_cases/test_config.c
C_SRCS += lvgl/tests/src/test_cases/test_demo_stress.c
C_SRCS += lvgl/tests/src/test_cases/test_demo_vector_graphic.c
C_SRCS += lvgl/tests/src/test_cases/test_demo_widgets.c
C_SRCS += lvgl/tests/src/test_cases/test_display.c
C_SRCS += lvgl/tests/src/test_cases/test_draw_buf.c
C_SRCS += lvgl/tests/src/test_cases/test_event.c
C_SRCS += lvgl/tests/src/test_cases/test_event_trickle.c
C_SRCS += lvgl/tests/src/test_cases/test_file_explorer.c
C_SRCS += lvgl/tests/src/test_cases/test_font_loader.c
C_SRCS += lvgl/tests/src/test_cases/test_font_manager.c
C_SRCS += lvgl/tests/src/test_cases/test_fs.c
C_SRCS += lvgl/tests/src/test_cases/test_gesture_pinch.c
C_SRCS += lvgl/tests/src/test_cases/test_grid.c
C_SRCS += lvgl/tests/src/test_cases/test_grid_fr.c
C_SRCS += lvgl/tests/src/test_cases/test_gridnav.c
C_SRCS += lvgl/tests/src/test_cases/test_group.c
C_SRCS += lvgl/tests/src/test_cases/test_hover.c
C_SRCS += lvgl/tests/src/test_cases/test_indev.c
C_SRCS += lvgl/tests/src/test_cases/test_lcd.c
C_SRCS += lvgl/tests/src/test_cases/test_margin_align.c
C_SRCS += lvgl/tests/src/test_cases/test_margin_flex.c
C_SRCS += lvgl/tests/src/test_cases/test_margin_grid.c
C_SRCS += lvgl/tests/src/test_cases/test_math.c
C_SRCS += lvgl/tests/src/test_cases/test_mem.c
C_SRCS += lvgl/tests/src/test_cases/test_observer.c
C_SRCS += lvgl/tests/src/test_cases/test_profiler.c
C_SRCS += lvgl/tests/src/test_cases/test_recolor.c
C_SRCS += lvgl/tests/src/test_cases/test_screen_load.c
C_SRCS += lvgl/tests/src/test_cases/test_snapshot.c
C_SRCS += lvgl/tests/src/test_cases/test_style.c
C_SRCS += lvgl/tests/src/test_cases/test_svg.c
C_SRCS += lvgl/tests/src/test_cases/test_svg_anim.c
C_SRCS += lvgl/tests/src/test_cases/test_theme.c
C_SRCS += lvgl/tests/src/test_cases/test_translation.c
C_SRCS += lvgl/tests/src/test_cases/test_tree.c
C_SRCS += lvgl/tests/src/test_cases/test_txt.c
C_SRCS += lvgl/tests/src/test_cases/widgets/test_animimg.c
C_SRCS += lvgl/tests/src/test_cases/widgets/test_arc.c
C_SRCS += lvgl/tests/src/test_cases/widgets/test_arclabel.c
C_SRCS += lvgl/tests/src/test_cases/widgets/test_bar.c
C_SRCS += lvgl/tests/src/test_cases/widgets/test_btn.c
C_SRCS += lvgl/tests/src/test_cases/widgets/test_btnmatrix.c
C_SRCS += lvgl/tests/src/test_cases/widgets/test_calendar.c
C_SRCS += lvgl/tests/src/test_cases/widgets/test_canvas.c
C_SRCS += lvgl/tests/src/test_cases/widgets/test_chart.c
C_SRCS += lvgl/tests/src/test_cases/widgets/test_checkbox.c
C_SRCS += lvgl/tests/src/test_cases/widgets/test_dropdown.c
C_SRCS += lvgl/tests/src/test_cases/widgets/test_image.c
C_SRCS += lvgl/tests/src/test_cases/widgets/test_imagebutton.c
C_SRCS += lvgl/tests/src/test_cases/widgets/test_imgfont.c
C_SRCS += lvgl/tests/src/test_cases/widgets/test_keyboard.c
C_SRCS += lvgl/tests/src/test_cases/widgets/test_label.c
C_SRCS += lvgl/tests/src/test_cases/widgets/test_led.c
C_SRCS += lvgl/tests/src/test_cases/widgets/test_line.c
C_SRCS += lvgl/tests/src/test_cases/widgets/test_list.c
C_SRCS += lvgl/tests/src/test_cases/widgets/test_lottie.c
C_SRCS += lvgl/tests/src/test_cases/widgets/test_msgbox.c
C_SRCS += lvgl/tests/src/test_cases/widgets/test_obj_flags.c
C_SRCS += lvgl/tests/src/test_cases/widgets/test_obj_pos.c
C_SRCS += lvgl/tests/src/test_cases/widgets/test_obj_property.c
C_SRCS += lvgl/tests/src/test_cases/widgets/test_obj_transform.c
C_SRCS += lvgl/tests/src/test_cases/widgets/test_obj_tree.c
C_SRCS += lvgl/tests/src/test_cases/widgets/test_objid.c
C_SRCS += lvgl/tests/src/test_cases/widgets/test_roller.c
C_SRCS += lvgl/tests/src/test_cases/widgets/test_scale.c
C_SRCS += lvgl/tests/src/test_cases/widgets/test_slider.c
C_SRCS += lvgl/tests/src/test_cases/widgets/test_span.c
C_SRCS += lvgl/tests/src/test_cases/widgets/test_spinbox.c
C_SRCS += lvgl/tests/src/test_cases/widgets/test_spinner.c
C_SRCS += lvgl/tests/src/test_cases/widgets/test_switch.c
C_SRCS += lvgl/tests/src/test_cases/widgets/test_table.c
C_SRCS += lvgl/tests/src/test_cases/widgets/test_tabview.c
C_SRCS += lvgl/tests/src/test_cases/widgets/test_textarea.c
C_SRCS += lvgl/tests/src/test_cases/widgets/test_win.c
C_SRCS += lvgl/tests/src/test_cases/xml/test_xml_arc.c
C_SRCS += lvgl/tests/src/test_cases/xml/test_xml_bar.c
C_SRCS += lvgl/tests/src/test_cases/xml/test_xml_buttonmatrix.c
C_SRCS += lvgl/tests/src/test_cases/xml/test_xml_calendar.c
C_SRCS += lvgl/tests/src/test_cases/xml/test_xml_canvas.c
C_SRCS += lvgl/tests/src/test_cases/xml/test_xml_chart.c
C_SRCS += lvgl/tests/src/test_cases/xml/test_xml_checkbox.c
C_SRCS += lvgl/tests/src/test_cases/xml/test_xml_dropdown.c
C_SRCS += lvgl/tests/src/test_cases/xml/test_xml_event.c
C_SRCS += lvgl/tests/src/test_cases/xml/test_xml_general.c
C_SRCS += lvgl/tests/src/test_cases/xml/test_xml_image.c
C_SRCS += lvgl/tests/src/test_cases/xml/test_xml_keyboard.c
C_SRCS += lvgl/tests/src/test_cases/xml/test_xml_label.c
C_SRCS += lvgl/tests/src/test_cases/xml/test_xml_names.c
C_SRCS += lvgl/tests/src/test_cases/xml/test_xml_qrcode.c
C_SRCS += lvgl/tests/src/test_cases/xml/test_xml_roller.c
C_SRCS += lvgl/tests/src/test_cases/xml/test_xml_scale.c
C_SRCS += lvgl/tests/src/test_cases/xml/test_xml_screen_event.c
C_SRCS += lvgl/tests/src/test_cases/xml/test_xml_slider.c
C_SRCS += lvgl/tests/src/test_cases/xml/test_xml_spangroup.c
C_SRCS += lvgl/tests/src/test_cases/xml/test_xml_spinbox.c
C_SRCS += lvgl/tests/src/test_cases/xml/test_xml_style.c
C_SRCS += lvgl/tests/src/test_cases/xml/test_xml_subject.c
C_SRCS += lvgl/tests/src/test_cases/xml/test_xml_switch.c
C_SRCS += lvgl/tests/src/test_cases/xml/test_xml_table.c
C_SRCS += lvgl/tests/src/test_cases/xml/test_xml_tabview.c
C_SRCS += lvgl/tests/src/test_cases/xml/test_xml_textarea.c
C_SRCS += lvgl/tests/src/test_cases/xml/test_xml_timeline.c
C_SRCS += lvgl/tests/src/test_cases/xml/test_xml_translations.c
C_SRCS += lvgl/tests/src/test_cases/xml/test_xml_view2.c
C_SRCS += lvgl/tests/src/test_cases/xml/test_xml_view3.c
C_SRCS += lvgl/tests/src/test_cases_perf/test_chart.c
C_SRCS += lvgl/tests/src/test_cases_perf/test_label.c
C_SRCS += lvgl/tests/src/test_cases_perf/test_math.c
C_SRCS += lvgl/tests/src/test_layout_switch.c
C_SRCS += lvgl/tests/src/test_libs/rnd_unicodes/lv_rnd_unicodes.c
C_SRCS += lvgl/tests/src/test_libs/rnd_unicodes/rnd_unicodes/src/library.c
C_SRCS += lvgl/tests/test_images/stride_align1/LZ4/test_A1_LZ4_align1.c
C_SRCS += lvgl/tests/test_images/stride_align1/LZ4/test_A2_LZ4_align1.c
C_SRCS += lvgl/tests/test_images/stride_align1/LZ4/test_A4_LZ4_align1.c
C_SRCS += lvgl/tests/test_images/stride_align1/LZ4/test_A8_LZ4_align1.c
C_SRCS += lvgl/tests/test_images/stride_align1/LZ4/test_ARGB8565_LZ4_align1.c
C_SRCS += lvgl/tests/test_images/stride_align1/LZ4/test_ARGB8888_LZ4_align1.c
C_SRCS += lvgl/tests/test_images/stride_align1/LZ4/test_ARGB8888_PREMULTIPLIED_LZ4_align1.c
C_SRCS += lvgl/tests/test_images/stride_align1/LZ4/test_I1_LZ4_align1.c
C_SRCS += lvgl/tests/test_images/stride_align1/LZ4/test_I2_LZ4_align1.c
C_SRCS += lvgl/tests/test_images/stride_align1/LZ4/test_I4_LZ4_align1.c
C_SRCS += lvgl/tests/test_images/stride_align1/LZ4/test_I8_LZ4_align1.c
C_SRCS += lvgl/tests/test_images/stride_align1/LZ4/test_L8_LZ4_align1.c
C_SRCS += lvgl/tests/test_images/stride_align1/LZ4/test_RGB565A8_LZ4_align1.c
C_SRCS += lvgl/tests/test_images/stride_align1/LZ4/test_RGB565_LZ4_align1.c
C_SRCS += lvgl/tests/test_images/stride_align1/LZ4/test_RGB565_SWAPPED_LZ4_align1.c
C_SRCS += lvgl/tests/test_images/stride_align1/LZ4/test_RGB888_LZ4_align1.c
C_SRCS += lvgl/tests/test_images/stride_align1/LZ4/test_XRGB8888_LZ4_align1.c
C_SRCS += lvgl/tests/test_images/stride_align1/RLE/test_A1_RLE_align1.c
C_SRCS += lvgl/tests/test_images/stride_align1/RLE/test_A2_RLE_align1.c
C_SRCS += lvgl/tests/test_images/stride_align1/RLE/test_A4_RLE_align1.c
C_SRCS += lvgl/tests/test_images/stride_align1/RLE/test_A8_RLE_align1.c
C_SRCS += lvgl/tests/test_images/stride_align1/RLE/test_ARGB8565_RLE_align1.c
C_SRCS += lvgl/tests/test_images/stride_align1/RLE/test_ARGB8888_PREMULTIPLIED_RLE_align1.c
C_SRCS += lvgl/tests/test_images/stride_align1/RLE/test_ARGB8888_RLE_align1.c
C_SRCS += lvgl/tests/test_images/stride_align1/RLE/test_I1_RLE_align1.c
C_SRCS += lvgl/tests/test_images/stride_align1/RLE/test_I2_RLE_align1.c
C_SRCS += lvgl/tests/test_images/stride_align1/RLE/test_I4_RLE_align1.c
C_SRCS += lvgl/tests/test_images/stride_align1/RLE/test_I8_RLE_align1.c
C_SRCS += lvgl/tests/test_images/stride_align1/RLE/test_L8_RLE_align1.c
C_SRCS += lvgl/tests/test_images/stride_align1/RLE/test_RGB565A8_RLE_align1.c
C_SRCS += lvgl/tests/test_images/stride_align1/RLE/test_RGB565_RLE_align1.c
C_SRCS += lvgl/tests/test_images/stride_align1/RLE/test_RGB565_SWAPPED_RLE_align1.c
C_SRCS += lvgl/tests/test_images/stride_align1/RLE/test_RGB888_RLE_align1.c
C_SRCS += lvgl/tests/test_images/stride_align1/RLE/test_XRGB8888_RLE_align1.c
C_SRCS += lvgl/tests/test_images/stride_align1/UNCOMPRESSED/test_A1_NONE_align1.c
C_SRCS += lvgl/tests/test_images/stride_align1/UNCOMPRESSED/test_A2_NONE_align1.c
C_SRCS += lvgl/tests/test_images/stride_align1/UNCOMPRESSED/test_A4_NONE_align1.c
C_SRCS += lvgl/tests/test_images/stride_align1/UNCOMPRESSED/test_A8_NONE_align1.c
C_SRCS += lvgl/tests/test_images/stride_align1/UNCOMPRESSED/test_ARGB8565_NONE_align1.c
C_SRCS += lvgl/tests/test_images/stride_align1/UNCOMPRESSED/test_ARGB8888_NONE_align1.c
C_SRCS += lvgl/tests/test_images/stride_align1/UNCOMPRESSED/test_ARGB8888_PREMULTIPLIED_NONE_align1.c
C_SRCS += lvgl/tests/test_images/stride_align1/UNCOMPRESSED/test_I1_NONE_align1.c
C_SRCS += lvgl/tests/test_images/stride_align1/UNCOMPRESSED/test_I2_NONE_align1.c
C_SRCS += lvgl/tests/test_images/stride_align1/UNCOMPRESSED/test_I4_NONE_align1.c
C_SRCS += lvgl/tests/test_images/stride_align1/UNCOMPRESSED/test_I8_NONE_align1.c
C_SRCS += lvgl/tests/test_images/stride_align1/UNCOMPRESSED/test_L8_NONE_align1.c
C_SRCS += lvgl/tests/test_images/stride_align1/UNCOMPRESSED/test_RGB565A8_NONE_align1.c
C_SRCS += lvgl/tests/test_images/stride_align1/UNCOMPRESSED/test_RGB565_NONE_align1.c
C_SRCS += lvgl/tests/test_images/stride_align1/UNCOMPRESSED/test_RGB565_SWAPPED_NONE_align1.c
C_SRCS += lvgl/tests/test_images/stride_align1/UNCOMPRESSED/test_RGB888_NONE_align1.c
C_SRCS += lvgl/tests/test_images/stride_align1/UNCOMPRESSED/test_XRGB8888_NONE_align1.c
C_SRCS += lvgl/tests/test_images/stride_align64/LZ4/test_A1_LZ4_align64.c
C_SRCS += lvgl/tests/test_images/stride_align64/LZ4/test_A2_LZ4_align64.c
C_SRCS += lvgl/tests/test_images/stride_align64/LZ4/test_A4_LZ4_align64.c
C_SRCS += lvgl/tests/test_images/stride_align64/LZ4/test_A8_LZ4_align64.c
C_SRCS += lvgl/tests/test_images/stride_align64/LZ4/test_ARGB8565_LZ4_align64.c
C_SRCS += lvgl/tests/test_images/stride_align64/LZ4/test_ARGB8888_LZ4_align64.c
C_SRCS += lvgl/tests/test_images/stride_align64/LZ4/test_ARGB8888_PREMULTIPLIED_LZ4_align64.c
C_SRCS += lvgl/tests/test_images/stride_align64/LZ4/test_I1_LZ4_align64.c
C_SRCS += lvgl/tests/test_images/stride_align64/LZ4/test_I2_LZ4_align64.c
C_SRCS += lvgl/tests/test_images/stride_align64/LZ4/test_I4_LZ4_align64.c
C_SRCS += lvgl/tests/test_images/stride_align64/LZ4/test_I8_LZ4_align64.c
C_SRCS += lvgl/tests/test_images/stride_align64/LZ4/test_L8_LZ4_align64.c
C_SRCS += lvgl/tests/test_images/stride_align64/LZ4/test_RGB565A8_LZ4_align64.c
C_SRCS += lvgl/tests/test_images/stride_align64/LZ4/test_RGB565_LZ4_align64.c
C_SRCS += lvgl/tests/test_images/stride_align64/LZ4/test_RGB565_SWAPPED_LZ4_align64.c
C_SRCS += lvgl/tests/test_images/stride_align64/LZ4/test_RGB888_LZ4_align64.c
C_SRCS += lvgl/tests/test_images/stride_align64/LZ4/test_XRGB8888_LZ4_align64.c
C_SRCS += lvgl/tests/test_images/stride_align64/RLE/test_A1_RLE_align64.c
C_SRCS += lvgl/tests/test_images/stride_align64/RLE/test_A2_RLE_align64.c
C_SRCS += lvgl/tests/test_images/stride_align64/RLE/test_A4_RLE_align64.c
C_SRCS += lvgl/tests/test_images/stride_align64/RLE/test_A8_RLE_align64.c
C_SRCS += lvgl/tests/test_images/stride_align64/RLE/test_ARGB8565_RLE_align64.c
C_SRCS += lvgl/tests/test_images/stride_align64/RLE/test_ARGB8888_PREMULTIPLIED_RLE_align64.c
C_SRCS += lvgl/tests/test_images/stride_align64/RLE/test_ARGB8888_RLE_align64.c
C_SRCS += lvgl/tests/test_images/stride_align64/RLE/test_I1_RLE_align64.c
C_SRCS += lvgl/tests/test_images/stride_align64/RLE/test_I2_RLE_align64.c
C_SRCS += lvgl/tests/test_images/stride_align64/RLE/test_I4_RLE_align64.c
C_SRCS += lvgl/tests/test_images/stride_align64/RLE/test_I8_RLE_align64.c
C_SRCS += lvgl/tests/test_images/stride_align64/RLE/test_L8_RLE_align64.c
C_SRCS += lvgl/tests/test_images/stride_align64/RLE/test_RGB565A8_RLE_align64.c
C_SRCS += lvgl/tests/test_images/stride_align64/RLE/test_RGB565_RLE_align64.c
C_SRCS += lvgl/tests/test_images/stride_align64/RLE/test_RGB565_SWAPPED_RLE_align64.c
C_SRCS += lvgl/tests/test_images/stride_align64/RLE/test_RGB888_RLE_align64.c
C_SRCS += lvgl/tests/test_images/stride_align64/RLE/test_XRGB8888_RLE_align64.c
C_SRCS += lvgl/tests/test_images/stride_align64/UNCOMPRESSED/test_A1_NONE_align64.c
C_SRCS += lvgl/tests/test_images/stride_align64/UNCOMPRESSED/test_A2_NONE_align64.c
C_SRCS += lvgl/tests/test_images/stride_align64/UNCOMPRESSED/test_A4_NONE_align64.c
C_SRCS += lvgl/tests/test_images/stride_align64/UNCOMPRESSED/test_A8_NONE_align64.c
C_SRCS += lvgl/tests/test_images/stride_align64/UNCOMPRESSED/test_ARGB8565_NONE_align64.c
C_SRCS += lvgl/tests/test_images/stride_align64/UNCOMPRESSED/test_ARGB8888_NONE_align64.c
C_SRCS += lvgl/tests/test_images/stride_align64/UNCOMPRESSED/test_ARGB8888_PREMULTIPLIED_NONE_align64.c
C_SRCS += lvgl/tests/test_images/stride_align64/UNCOMPRESSED/test_I1_NONE_align64.c
C_SRCS += lvgl/tests/test_images/stride_align64/UNCOMPRESSED/test_I2_NONE_align64.c
C_SRCS += lvgl/tests/test_images/stride_align64/UNCOMPRESSED/test_I4_NONE_align64.c
C_SRCS += lvgl/tests/test_images/stride_align64/UNCOMPRESSED/test_I8_NONE_align64.c
C_SRCS += lvgl/tests/test_images/stride_align64/UNCOMPRESSED/test_L8_NONE_align64.c
C_SRCS += lvgl/tests/test_images/stride_align64/UNCOMPRESSED/test_RGB565A8_NONE_align64.c
C_SRCS += lvgl/tests/test_images/stride_align64/UNCOMPRESSED/test_RGB565_NONE_align64.c
C_SRCS += lvgl/tests/test_images/stride_align64/UNCOMPRESSED/test_RGB565_SWAPPED_NONE_align64.c
C_SRCS += lvgl/tests/test_images/stride_align64/UNCOMPRESSED/test_RGB888_NONE_align64.c
C_SRCS += lvgl/tests/test_images/stride_align64/UNCOMPRESSED/test_XRGB8888_NONE_align64.c
C_SRCS += lvgl/tests/unity/unity.c
CXX_SRCS += lvgl/src/drivers/display/lovyan_gfx/lv_lovyan_gfx.cpp
CXX_SRCS += lvgl/src/drivers/display/tft_espi/lv_tft_espi.cpp
CXX_SRCS += lvgl/src/libs/fsdrv/lv_fs_arduino_esp_littlefs.cpp
CXX_SRCS += lvgl/src/libs/fsdrv/lv_fs_arduino_sd.cpp
CXX_SRCS += lvgl/src/libs/gltf/gltf_data/lv_gltf_bind.cpp
CXX_SRCS += lvgl/src/libs/gltf/gltf_data/lv_gltf_data.cpp
CXX_SRCS += lvgl/src/libs/gltf/gltf_data/lv_gltf_data_animations.cpp
CXX_SRCS += lvgl/src/libs/gltf/gltf_data/lv_gltf_data_cache.cpp
CXX_SRCS += lvgl/src/libs/gltf/gltf_data/lv_gltf_data_injest.cpp
CXX_SRCS += lvgl/src/libs/gltf/gltf_data/lv_gltf_data_mesh.cpp
CXX_SRCS += lvgl/src/libs/gltf/gltf_data/lv_gltf_data_node.cpp
CXX_SRCS += lvgl/src/libs/gltf/gltf_data/lv_gltf_data_primitive.cpp
CXX_SRCS += lvgl/src/libs/gltf/gltf_data/lv_gltf_data_shader.cpp
CXX_SRCS += lvgl/src/libs/gltf/gltf_data/lv_gltf_data_skin.cpp
CXX_SRCS += lvgl/src/libs/gltf/gltf_data/lv_gltf_data_texture.cpp
CXX_SRCS += lvgl/src/libs/gltf/gltf_data/lv_gltf_uniform_locations.cpp
CXX_SRCS += lvgl/src/libs/gltf/gltf_view/lv_gltf_view.cpp
CXX_SRCS += lvgl/src/libs/gltf/gltf_view/lv_gltf_view_render.cpp
CXX_SRCS += lvgl/src/libs/gltf/gltf_view/lv_gltf_view_shader.cpp
CXX_SRCS += lvgl/src/libs/gltf/math/lv_gltf_math.cpp
CXX_SRCS += lvgl/src/libs/thorvg/tvgAccessor.cpp
CXX_SRCS += lvgl/src/libs/thorvg/tvgAnimation.cpp
CXX_SRCS += lvgl/src/libs/thorvg/tvgCanvas.cpp
CXX_SRCS += lvgl/src/libs/thorvg/tvgCapi.cpp
CXX_SRCS += lvgl/src/libs/thorvg/tvgCompressor.cpp
CXX_SRCS += lvgl/src/libs/thorvg/tvgFill.cpp
CXX_SRCS += lvgl/src/libs/thorvg/tvgGlCanvas.cpp
CXX_SRCS += lvgl/src/libs/thorvg/tvgInitializer.cpp
CXX_SRCS += lvgl/src/libs/thorvg/tvgLoader.cpp
CXX_SRCS += lvgl/src/libs/thorvg/tvgLottieAnimation.cpp
CXX_SRCS += lvgl/src/libs/thorvg/tvgLottieBuilder.cpp
CXX_SRCS += lvgl/src/libs/thorvg/tvgLottieExpressions.cpp
CXX_SRCS += lvgl/src/libs/thorvg/tvgLottieInterpolator.cpp
CXX_SRCS += lvgl/src/libs/thorvg/tvgLottieLoader.cpp
CXX_SRCS += lvgl/src/libs/thorvg/tvgLottieModel.cpp
CXX_SRCS += lvgl/src/libs/thorvg/tvgLottieModifier.cpp
CXX_SRCS += lvgl/src/libs/thorvg/tvgLottieParser.cpp
CXX_SRCS += lvgl/src/libs/thorvg/tvgLottieParserHandler.cpp
CXX_SRCS += lvgl/src/libs/thorvg/tvgMath.cpp
CXX_SRCS += lvgl/src/libs/thorvg/tvgPaint.cpp
CXX_SRCS += lvgl/src/libs/thorvg/tvgPicture.cpp
CXX_SRCS += lvgl/src/libs/thorvg/tvgRawLoader.cpp
CXX_SRCS += lvgl/src/libs/thorvg/tvgRender.cpp
CXX_SRCS += lvgl/src/libs/thorvg/tvgSaver.cpp
CXX_SRCS += lvgl/src/libs/thorvg/tvgScene.cpp
CXX_SRCS += lvgl/src/libs/thorvg/tvgShape.cpp
CXX_SRCS += lvgl/src/libs/thorvg/tvgStr.cpp
CXX_SRCS += lvgl/src/libs/thorvg/tvgSvgCssStyle.cpp
CXX_SRCS += lvgl/src/libs/thorvg/tvgSvgLoader.cpp
CXX_SRCS += lvgl/src/libs/thorvg/tvgSvgPath.cpp
CXX_SRCS += lvgl/src/libs/thorvg/tvgSvgSceneBuilder.cpp
CXX_SRCS += lvgl/src/libs/thorvg/tvgSvgUtil.cpp
CXX_SRCS += lvgl/src/libs/thorvg/tvgSwCanvas.cpp
CXX_SRCS += lvgl/src/libs/thorvg/tvgSwFill.cpp
CXX_SRCS += lvgl/src/libs/thorvg/tvgSwImage.cpp
CXX_SRCS += lvgl/src/libs/thorvg/tvgSwMath.cpp
CXX_SRCS += lvgl/src/libs/thorvg/tvgSwMemPool.cpp
CXX_SRCS += lvgl/src/libs/thorvg/tvgSwPostEffect.cpp
CXX_SRCS += lvgl/src/libs/thorvg/tvgSwRaster.cpp
CXX_SRCS += lvgl/src/libs/thorvg/tvgSwRenderer.cpp
CXX_SRCS += lvgl/src/libs/thorvg/tvgSwRle.cpp
CXX_SRCS += lvgl/src/libs/thorvg/tvgSwShape.cpp
CXX_SRCS += lvgl/src/libs/thorvg/tvgSwStroke.cpp
CXX_SRCS += lvgl/src/libs/thorvg/tvgTaskScheduler.cpp
CXX_SRCS += lvgl/src/libs/thorvg/tvgText.cpp
CXX_SRCS += lvgl/src/libs/thorvg/tvgWgCanvas.cpp
CXX_SRCS += lvgl/src/libs/thorvg/tvgXmlParser.cpp
CXX_SRCS += lvgl/src/others/vg_lite_tvg/vg_lite_tvg.cpp
ASM_SRCS := lvgl/src/draw/sw/blend/helium/lv_blend_helium.S


# Path to root of object file tree.
OBJ_ROOT_DIR := obj

# Options to control objdump.
CREATE_OBJDUMP := 1
OBJDUMP_INCLUDE_SOURCE := 0
OBJDUMP_FULL_CONTENTS := 0

# Options to enable/disable optional files.
CREATE_ELF_DERIVED_FILES := 0
CREATE_LINKER_MAP := 1

# Common arguments for ALT_CFLAGSs
APP_CFLAGS_DEFINED_SYMBOLS :=
APP_CFLAGS_UNDEFINED_SYMBOLS :=
APP_CFLAGS_OPTIMIZATION := -O3
APP_CFLAGS_DEBUG_LEVEL := -g
APP_CFLAGS_WARNINGS := -Wall
APP_CFLAGS_USER_FLAGS :=

APP_ASFLAGS_USER :=
APP_LDFLAGS_USER :=

# Linker options that have default values assigned later if not
# assigned here.
LINKER_SCRIPT :=
CRT0 :=
SYS_LIB :=

# Define path to the root of the BSP.
BSP_ROOT_DIR := ../lcd-dma-bsp/

# List of application specific include directories, library directories and library names
APP_INCLUDE_DIRS := ./
APP_LIBRARY_DIRS :=
APP_LIBRARY_NAMES :=

# Pre- and post- processor settings.
BUILD_PRE_PROCESS :=
BUILD_POST_PROCESS :=



#END GENERATED

#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
#                            GENERATED SETTINGS END                           ^
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^


#------------------------------------------------------------------------------
#                           DEFAULT TARGET
#------------------------------------------------------------------------------

# Define the variable used to echo output if not already defined.
ifeq ($(ECHO),)
ECHO := echo
endif

# Put "all" rule before included makefile fragments because they may
# define rules and we don't want one of those to become the default rule.
.PHONY : all

all:
	@$(ECHO) [$(APP_NAME) build complete]

all : build_pre_process libs app build_post_process 


#------------------------------------------------------------------------------
#                 VARIABLES DEPENDENT ON GENERATED CONTENT
#------------------------------------------------------------------------------

# Define object file directory per build configuration
CONFIG_OBJ_DIR := $(OBJ_ROOT_DIR)/$(ACTIVE_BUILD_CONFIG)

ifeq ($(BSP_ROOT_DIR),)
$(error Edit Makefile and provide a value for BSP_ROOT_DIR)
endif

ifeq ($(wildcard $(BSP_ROOT_DIR)),)
$(error BSP directory does not exist: $(BSP_ROOT_DIR))
endif

# Define absolute path to the root of the BSP.
ABS_BSP_ROOT_DIR := $(call adjust-path-mixed,$(shell cd "$(BSP_ROOT_DIR)"; pwd))

# Include makefile fragments.  Define variable ALT_LIBRARY_ROOT_DIR before
# including each makefile fragment so that it knows the path to itself.
BSP_INCLUDE_FILE := $(BSP_ROOT_DIR)/public.mk
ALT_LIBRARY_ROOT_DIR := $(BSP_ROOT_DIR)
include $(BSP_INCLUDE_FILE)
# C2H will need this to touch the BSP public.mk and avoid the sopc file 
# out-of-date error during a BSP make
ABS_BSP_INCLUDE_FILE := $(ABS_BSP_ROOT_DIR)/public.mk


ifneq ($(WARNING.SMALL_STACK_SIZE),)
# This WARNING is here to protect you from unknowingly using a very small stack
# If the warning is set, increase your stack size or enable the BSP small stack 
# setting to eliminate the warning
$(warning WARNING: $(WARNING.SMALL_STACK_SIZE))
endif

# If the BSP public.mk indicates that ALT_SIM_OPTIMIZE is set, rename the ELF 
# by prefixing it with RUN_ON_HDL_SIMULATOR_ONLY_.  
ifneq ($(filter -DALT_SIM_OPTIMIZE,$(ALT_CPPFLAGS)),)
ELF := RUN_ON_HDL_SIMULATOR_ONLY_$(ELF)
endif

# If the BSP public.mk indicates that ALT_PROVIDE_GMON is set, add option to 
# download_elf target
ifneq ($(filter -DALT_PROVIDE_GMON,$(ALT_CPPFLAGS)),)
GMON_OUT_FILENAME := gmon.out
WRITE_GMON_OPTION := --write-gmon $(GMON_OUT_FILENAME)
endif

# Name of ELF application.
APP_NAME := $(basename $(ELF))

# Set to defaults if variables not already defined in settings.
ifeq ($(LINKER_SCRIPT),)
LINKER_SCRIPT := $(BSP_LINKER_SCRIPT)
endif
ifeq ($(CRT0),)
CRT0 := $(BSP_CRT0)
endif
ifeq ($(SYS_LIB),)
SYS_LIB := $(BSP_SYS_LIB)
endif

OBJDUMP_NAME := $(APP_NAME).objdump
OBJDUMP_FLAGS := --disassemble --syms --all-header
ifeq ($(OBJDUMP_INCLUDE_SOURCE),1)
OBJDUMP_FLAGS += --source
endif
ifeq ($(OBJDUMP_FULL_CONTENTS),1)
OBJDUMP_FLAGS += --full-contents
endif

# Create list of linker dependencies (*.a files).
APP_LDDEPS := $(ALT_LDDEPS) $(LDDEPS)

# Take lists and add required prefixes.
APP_INC_DIRS := $(addprefix -I, $(ALT_INCLUDE_DIRS) $(APP_INCLUDE_DIRS) $(INC_DIRS))
ASM_INC_PREFIX := -Wa,-I
APP_ASM_INC_DIRS := $(addprefix $(ASM_INC_PREFIX), $(ALT_INCLUDE_DIRS) $(APP_INCLUDE_DIRS) $(INC_DIRS))
APP_LIB_DIRS := $(addprefix -L, $(ALT_LIBRARY_DIRS) $(APP_LIBRARY_DIRS) $(LIB_DIRS))
APP_LIBS := $(addprefix -l, $(ALT_LIBRARY_NAMES) $(APP_LIBRARY_NAMES) $(LIBS))

ifneq ($(AVOID_NIOS2_GCC3_OPTIONS),)

#
# Avoid Nios II GCC 3.X options.
#

# Detect if small newlib C library is requested.
# If yes, remove the -msmallc option because it is
# now handled by other means.
ifneq ($(filter -msmallc,$(ALT_LDFLAGS)),)
	ALT_LDFLAGS := $(filter-out -msmallc,$(ALT_LDFLAGS))
	ALT_C_LIBRARY := smallc
else
	ALT_C_LIBRARY := c
endif

# Put each BSP dependent library in a group to avoid circular dependencies.
APP_BSP_DEP_LIBS := $(foreach l,$(ALT_BSP_DEP_LIBRARY_NAMES),-Wl,--start-group -l$(ALT_C_LIBRARY) -lgcc -lm -l$(l) -Wl,--end-group)

else # !AVOID_NIOS2_GCC3_OPTIONS

#
# Use Nios II GCC 3.X options.
#
ALT_BSP_DEP_LIBRARY_NAMES += $(ALT_BSP_DEP_LIBRARY_NAMES) m
APP_BSP_DEP_LIBS := $(addprefix -msys-lib=, $(ALT_BSP_DEP_LIBRARY_NAMES))

endif # !AVOID_NIOS2_GCC3_OPTIONS

# Arguments for the C preprocessor, C/C++ compiler, assembler, and linker.
APP_CFLAGS := $(APP_CFLAGS_DEFINED_SYMBOLS) \
              $(APP_CFLAGS_UNDEFINED_SYMBOLS) \
              $(APP_CFLAGS_OPTIMIZATION) \
              $(APP_CFLAGS_DEBUG_LEVEL) \
              $(APP_CFLAGS_WARNINGS) \
              $(APP_CFLAGS_USER_FLAGS) \
              $(ALT_CFLAGS) \
              $(CFLAGS)

# Arguments only for the C++ compiler.
APP_CXXFLAGS := $(ALT_CXXFLAGS) $(CXXFLAGS)

# Arguments only for the C preprocessor.
# Prefix each include directory with -I.
APP_CPPFLAGS := $(APP_INC_DIRS) \
                $(ALT_CPPFLAGS) \
                $(CPPFLAGS)

# Arguments only for the assembler.
APP_ASFLAGS := $(APP_ASM_INC_DIRS) \
               $(ALT_ASFLAGS) \
               $(APP_ASFLAGS_USER) \
               $(ASFLAGS)

# Arguments only for the linker.
APP_LDFLAGS := $(APP_LDFLAGS_USER)

ifneq ($(LINKER_SCRIPT),)
APP_LDFLAGS += -T'$(LINKER_SCRIPT)'
endif

ifneq ($(AVOID_NIOS2_GCC3_OPTIONS),)

# Avoid Nios II GCC 3.x options.
ifneq ($(CRT0),)
APP_LDFLAGS += $(CRT0)
endif

# The equivalent of the -msys-lib option is provided
# by the GROUP() command in the linker script.
# Note this means the SYS_LIB variable is now ignored.

else # !AVOID_NIOS2_GCC3_OPTIONS

# Use Nios II GCC 3.x options.
ifneq ($(CRT0),)
APP_LDFLAGS += -msys-crt0='$(CRT0)'
endif
ifneq ($(SYS_LIB),)
APP_LDFLAGS += -msys-lib=$(SYS_LIB)
endif

endif # !AVOID_NIOS2_GCC3_OPTIONS

APP_LDFLAGS += \
           $(APP_LIB_DIRS) \
           $(ALT_LDFLAGS) \
           $(LDFLAGS)

LINKER_MAP_NAME := $(APP_NAME).map
ifeq ($(CREATE_LINKER_MAP), 1)
APP_LDFLAGS += -Wl,-Map=$(LINKER_MAP_NAME)
endif

# QUARTUS_PROJECT_DIR and SOPC_NAME need to be defined if you want the 
# mem_init_install target of the mem_init.mk (located in the associated BSP) 
# to know how to copy memory initialization files (e.g. .dat, .hex) into 
# directories required for Quartus compilation or RTL simulation.

# Defining QUARTUS_PROJECT_DIR causes mem_init_install to copy memory 
# initialization files into your Quartus project directory. This is required 
# to provide the initial memory contents of FPGA memories that can be 
# initialized by the programming file (.sof) or Hardcopy ROMs. It is also used 
# for VHDL simulation of on-chip memories.

# Defining SOPC_NAME causes the mem_init_install target to copy memory 
# initialization files into your RTL simulation directory.  This is required 
# to provide the initial memory contents of all memories that can be 
# initialized by RTL simulation. This variable should be set to the same name 
# as your SOPC Builder system name. For example, if you have a system called 
# "foo.sopc", this variable should be set to "foo".

# If SOPC_NAME is not set and QUARTUS_PROJECT_DIR is set, then derive SOPC_NAME.
ifeq ($(SOPC_NAME),)
ifneq ($(QUARTUS_PROJECT_DIR),)
SOPC_NAME := $(basename $(notdir $(wildcard $(QUARTUS_PROJECT_DIR)/*.sopcinfo)))
endif
endif

# Defining JDI_FILE is required to specify the JTAG Debug Information File 
# path. This file is generated by Quartus, and is needed along with the 
# .sopcinfo file to resolve processor instance ID's from names in a multi-CPU 
# systems. For multi-CPU systems, the processor instance ID is used to select 
# from multiple CPU's during ELF download.

# Both JDI_FILE and SOPCINFO_FILE are provided by the BSP if they found during 
# BSP creation. If JDI_FILE is not set and QUARTUS_PROJECT_DIR is set, then 
# derive JDI_FILE. We do not attempt to derive SOPCINFO_FILE since there may be 
# multiple .sopcinfo files in a Quartus project. 
ifeq ($(JDI_FILE),)
ifneq ($(QUARTUS_PROJECT_DIR),)
JDI_FILE := $(firstword $(wildcard $(QUARTUS_PROJECT_DIR)/output_files/*.jdi) $(wildcard $(QUARTUS_PROJECT_DIR)/*.jdi))
endif
endif

# Path to root runtime directory used for hdl simulation 
RUNTIME_ROOT_DIR := $(CONFIG_OBJ_DIR)/runtime



#------------------------------------------------------------------------------
#           MAKEFILE INCLUDES DEPENDENT ON GENERATED CONTENT
#------------------------------------------------------------------------------
# mem_init.mk is a generated makefile fragment. This file defines all targets
# used to generate HDL initialization simulation files and pre-initialized
# onchip memory files.
MEM_INIT_FILE :=  $(BSP_ROOT_DIR)/mem_init.mk
include $(MEM_INIT_FILE)

# Create list of object files to be built using the list of source files.
# The source file hierarchy is preserved in the object tree.
# The supported file extensions are:
#
# .c            - for C files
# .cxx .cc .cpp - for C++ files
# .S .s         - for assembler files
#
# Handle source files specified by --src-dir & --src-rdir differently, to
# save some processing time in calling the adjust-path macro.

OBJ_LIST_C 		:= $(patsubst %.c,%.o,$(filter %.c,$(C_SRCS)))
OBJ_LIST_CPP	:= $(patsubst %.cpp,%.o,$(filter %.cpp,$(CXX_SRCS)))
OBJ_LIST_CXX 	:= $(patsubst %.cxx,%.o,$(filter %.cxx,$(CXX_SRCS)))
OBJ_LIST_CC 	:= $(patsubst %.cc,%.o,$(filter %.cc,$(CXX_SRCS)))
OBJ_LIST_S 		:= $(patsubst %.S,%.o,$(filter %.S,$(ASM_SRCS)))
OBJ_LIST_SS		:= $(patsubst %.s,%.o,$(filter %.s,$(ASM_SRCS)))

OBJ_LIST := $(sort $(OBJ_LIST_C) $(OBJ_LIST_CPP) $(OBJ_LIST_CXX) \
				$(OBJ_LIST_CC) $(OBJ_LIST_S) $(OBJ_LIST_SS))

SDIR_OBJ_LIST_C		:= $(patsubst %.c,%.o,$(filter %.c,$(SDIR_C_SRCS)))
SDIR_OBJ_LIST_CPP	:= $(patsubst %.cpp,%.o,$(filter %.cpp,$(SDIR_CXX_SRCS)))
SDIR_OBJ_LIST_CXX 	:= $(patsubst %.cxx,%.o,$(filter %.cxx,$(SDIR_CXX_SRCS)))
SDIR_OBJ_LIST_CC 	:= $(patsubst %.cc,%.o,$(filter %.cc,$(SDIR_CXX_SRCS)))
SDIR_OBJ_LIST_S		:= $(patsubst %.S,%.o,$(filter %.S,$(SDIR_ASM_SRCS)))
SDIR_OBJ_LIST_SS	:= $(patsubst %.s,%.o,$(filter %.s,$(SDIR_ASM_SRCS)))

SDIR_OBJ_LIST := $(sort $(SDIR_OBJ_LIST_C) $(SDIR_OBJ_LIST_CPP) \
				$(SDIR_OBJ_LIST_CXX) $(SDIR_OBJ_LIST_CC) $(SDIR_OBJ_LIST_S) \
				$(SDIR_OBJ_LIST_SS))

# Relative-pathed objects that being with "../" are handled differently.
#
# Regular objects are created as 
#   $(CONFIG_OBJ_DIR)/<path>/<filename>.o
# where the path structure is maintained under the obj directory.  This
# applies for both absolute and relative paths; in the absolute path
# case this means the entire source path will be recreated under the obj
# directory.  This is done to allow two source files with the same name
# to be included as part of the project.
#
# Note: On Cygwin, the path recreated under the obj directory will be 
# the cygpath -u output path.
#
# Relative-path objects that begin with "../" cause problems under this 
# scheme, as $(CONFIG_OBJ_DIR)/../<rest of path>/ can potentially put the object
# files anywhere in the system, creating clutter and polluting the source tree.
# As such, their paths are flattened - the object file created will be 
# $(CONFIG_OBJ_DIR)/<filename>.o.  Due to this, two files specified with 
# "../" in the beginning cannot have the same name in the project.  VPATH 
# will be set for these sources to allow make to relocate the source file 
# via %.o rules.
#
# The following lines separate the object list into the flatten and regular
# lists, and then handles them as appropriate.

FLATTEN_OBJ_LIST := $(filter ../%,$(OBJ_LIST))
FLATTEN_APP_OBJS := $(addprefix $(CONFIG_OBJ_DIR)/,$(notdir $(FLATTEN_OBJ_LIST)))

REGULAR_OBJ_LIST 		:= $(filter-out $(FLATTEN_OBJ_LIST),$(OBJ_LIST))
REGULAR_OBJ_LIST_C 		:= $(filter $(OBJ_LIST_C),$(REGULAR_OBJ_LIST))
REGULAR_OBJ_LIST_CPP	:= $(filter $(OBJ_LIST_CPP),$(REGULAR_OBJ_LIST))
REGULAR_OBJ_LIST_CXX 	:= $(filter $(OBJ_LIST_CXX),$(REGULAR_OBJ_LIST))
REGULAR_OBJ_LIST_CC 	:= $(filter $(OBJ_LIST_CC),$(REGULAR_OBJ_LIST))
REGULAR_OBJ_LIST_S 		:= $(filter $(OBJ_LIST_S),$(REGULAR_OBJ_LIST))
REGULAR_OBJ_LIST_SS		:= $(filter $(OBJ_LIST_SS),$(REGULAR_OBJ_LIST))

FLATTEN_SDIR_OBJ_LIST := $(filter ../%,$(SDIR_OBJ_LIST))
FLATTEN_SDIR_APP_OBJS := $(addprefix $(CONFIG_OBJ_DIR)/,$(notdir $(FLATTEN_SDIR_OBJ_LIST)))

REGULAR_SDIR_OBJ_LIST 		:= $(filter-out $(FLATTEN_SDIR_OBJ_LIST),$(SDIR_OBJ_LIST))
REGULAR_SDIR_OBJ_LIST_C 	:= $(filter $(SDIR_OBJ_LIST_C),$(REGULAR_SDIR_OBJ_LIST))
REGULAR_SDIR_OBJ_LIST_CPP	:= $(filter $(SDIR_OBJ_LIST_CPP),$(REGULAR_SDIR_OBJ_LIST))
REGULAR_SDIR_OBJ_LIST_CXX 	:= $(filter $(SDIR_OBJ_LIST_CXX),$(REGULAR_SDIR_OBJ_LIST))
REGULAR_SDIR_OBJ_LIST_CC 	:= $(filter $(SDIR_OBJ_LIST_CC),$(REGULAR_SDIR_OBJ_LIST))
REGULAR_SDIR_OBJ_LIST_S 	:= $(filter $(SDIR_OBJ_LIST_S),$(REGULAR_SDIR_OBJ_LIST))
REGULAR_SDIR_OBJ_LIST_SS	:= $(filter $(SDIR_OBJ_LIST_SS),$(REGULAR_SDIR_OBJ_LIST))

VPATH := $(sort $(dir $(FLATTEN_OBJ_LIST)) $(dir $(FLATTEN_SDIR_OBJ_LIST)))

APP_OBJS_C := $(addprefix $(CONFIG_OBJ_DIR)/,\
	$(REGULAR_SDIR_OBJ_LIST_C) \
	$(foreach s,$(REGULAR_OBJ_LIST_C),$(call adjust-path,$s)))

APP_OBJS_CPP := $(addprefix $(CONFIG_OBJ_DIR)/,\
	$(REGULAR_SDIR_OBJ_LIST_CPP) \
	$(foreach s,$(REGULAR_OBJ_LIST_CPP),$(call adjust-path,$s)))

APP_OBJS_CXX := $(addprefix $(CONFIG_OBJ_DIR)/,\
	$(REGULAR_SDIR_OBJ_LIST_CXX) \
	$(foreach s,$(REGULAR_OBJ_LIST_CXX),$(call adjust-path,$s)))

APP_OBJS_CC := $(addprefix $(CONFIG_OBJ_DIR)/,\
	$(REGULAR_SDIR_OBJ_LIST_CC) \
	$(foreach s,$(REGULAR_OBJ_LIST_CC),$(call adjust-path,$s)))

APP_OBJS_S := $(addprefix $(CONFIG_OBJ_DIR)/,\
	$(REGULAR_SDIR_OBJ_LIST_S) \
	$(foreach s,$(REGULAR_OBJ_LIST_S),$(call adjust-path,$s)))

APP_OBJS_SS := $(addprefix $(CONFIG_OBJ_DIR)/,\
	$(REGULAR_SDIR_OBJ_LIST_SS) \
	$(foreach s,$(REGULAR_OBJ_LIST_SS),$(call adjust-path,$s)))

APP_OBJS := $(APP_OBJS_C) $(APP_OBJS_CPP) $(APP_OBJS_CXX) $(APP_OBJS_CC) \
	$(APP_OBJS_S) $(APP_OBJS_SS) \
	$(FLATTEN_APP_OBJS) $(FLATTEN_SDIR_APP_OBJS)

# Add any extra user-provided object files.
APP_OBJS += $(OBJS)

# Create list of dependancy files for each object file.
APP_DEPS := $(APP_OBJS:.o=.d)

# Patch the Elf file with system specific information

# Patch the Elf with the name of the sopc system
ifneq ($(SOPC_NAME),)
ELF_PATCH_FLAG += --sopc_system_name $(SOPC_NAME)
endif

# Patch the Elf with the absolute path to the Quartus Project Directory
ifneq ($(QUARTUS_PROJECT_DIR),)
ABS_QUARTUS_PROJECT_DIR := $(call adjust-path-mixed,$(shell cd "$(QUARTUS_PROJECT_DIR)"; pwd))
ELF_PATCH_FLAG += --quartus_project_dir "$(ABS_QUARTUS_PROJECT_DIR)"
endif

# Patch the Elf and download args with the JDI_FILE if specified
ifneq ($(wildcard $(JDI_FILE)),)
ELF_PATCH_FLAG += --jdi $(JDI_FILE)
DOWNLOAD_JDI_FLAG := --jdi $(JDI_FILE)
endif

# Patch the Elf with the SOPCINFO_FILE if specified
ifneq ($(wildcard $(SOPCINFO_FILE)),)
ELF_PATCH_FLAG += --sopcinfo $(SOPCINFO_FILE)
endif

# Use the DOWNLOAD_CABLE variable to specify which JTAG cable to use. 
# This is not needed if you only have one cable.
ifneq ($(DOWNLOAD_CABLE),)
DOWNLOAD_CABLE_FLAG := --cable '$(DOWNLOAD_CABLE)'
endif


#------------------------------------------------------------------------------
#                           BUILD PRE/POST PROCESS
#------------------------------------------------------------------------------
build_pre_process :
	$(BUILD_PRE_PROCESS)

build_post_process :
	$(BUILD_POST_PROCESS)

.PHONY: build_pre_process build_post_process


#------------------------------------------------------------------------------
#                                 TOOLS
#------------------------------------------------------------------------------

#
# Set tool default variables if not already defined.
# If these are defined, they would typically be defined in an
# included makefile fragment.
#
ifeq ($(DEFAULT_CROSS_COMPILE),)
DEFAULT_CROSS_COMPILE := nios2-elf-
endif

ifeq ($(DEFAULT_STACKREPORT),)
DEFAULT_STACKREPORT := nios2-stackreport
endif

ifeq ($(DEFAULT_DOWNLOAD),)
DEFAULT_DOWNLOAD := nios2-download
endif

ifeq ($(DEFAULT_FLASHPROG),)
DEFAULT_FLASHPROG := nios2-flash-programmer
endif

ifeq ($(DEFAULT_ELFPATCH),)
DEFAULT_ELFPATCH := nios2-elf-insert
endif

ifeq ($(DEFAULT_RM),)
DEFAULT_RM := rm -f
endif

ifeq ($(DEFAULT_CP),)
DEFAULT_CP := cp -f
endif

ifeq ($(DEFAULT_MKDIR),)
DEFAULT_MKDIR := mkdir -p
endif

#
# Set tool variables to defaults if not already defined.
# If these are defined, they would typically be defined by a
# setting in the generated portion of this makefile.
#
ifeq ($(CROSS_COMPILE),)
CROSS_COMPILE := $(DEFAULT_CROSS_COMPILE)
endif

ifeq ($(origin CC),default)
CC := $(CROSS_COMPILE)gcc -xc
endif

ifeq ($(origin CXX),default)
CXX := $(CROSS_COMPILE)gcc -xc++
endif

ifeq ($(origin AS),default)
AS := $(CROSS_COMPILE)gcc
endif

ifeq ($(origin AR),default)
AR := $(CROSS_COMPILE)ar
endif

ifeq ($(origin LD),default)
LD := $(CROSS_COMPILE)g++
endif

ifeq ($(origin RM),default)
RM := $(DEFAULT_RM)
endif

ifeq ($(NM),)
NM := $(CROSS_COMPILE)nm
endif

ifeq ($(CP),)
CP := $(DEFAULT_CP)
endif

ifeq ($(OBJDUMP),)
OBJDUMP := $(CROSS_COMPILE)objdump
endif

ifeq ($(OBJCOPY),)
OBJCOPY := $(CROSS_COMPILE)objcopy
endif

ifeq ($(STACKREPORT),)
STACKREPORT := $(DEFAULT_STACKREPORT) --prefix $(CROSS_COMPILE)
else
DISABLE_STACKREPORT := 1
endif

ifeq ($(DOWNLOAD),)
DOWNLOAD := $(DEFAULT_DOWNLOAD)
endif

ifeq ($(FLASHPROG),)
FLASHPROG := $(DEFAULT_FLASHPROG)
endif

ifeq ($(ELFPATCH),)
ELFPATCH := $(DEFAULT_ELFPATCH)
endif

ifeq ($(MKDIR),)
MKDIR := $(DEFAULT_MKDIR)
endif

#------------------------------------------------------------------------------
#                     PATTERN RULES TO BUILD OBJECTS
#------------------------------------------------------------------------------

define compile.c
@$(ECHO) Info: Compiling $< to $@
@$(MKDIR) $(@D)
$(CC) -MP -MMD -c $(APP_CPPFLAGS) $(APP_CFLAGS) -o $@ $<
$(CC_POST_PROCESS)
endef

define compile.cpp
@$(ECHO) Info: Compiling $< to $@
@$(MKDIR) $(@D)
$(CXX) -MP -MMD -c $(APP_CPPFLAGS) $(APP_CXXFLAGS) $(APP_CFLAGS) -o $@ $<
$(CXX_POST_PROCESS)
endef

# If assembling with the compiler, ensure "-Wa," is prepended to all APP_ASFLAGS
ifeq ($(AS),$(patsubst %as,%,$(AS)))
COMMA := ,
APP_ASFLAGS :=  $(filter-out $(APP_CFLAGS),$(addprefix -Wa$(COMMA),$(patsubst -Wa$(COMMA)%,%,$(APP_ASFLAGS))))
endif

define compile.s
@$(ECHO) Info: Assembling $< to $@
@$(MKDIR) $(@D)
$(AS) -MP -MMD -c $(APP_CPPFLAGS) $(APP_CFLAGS) $(APP_ASFLAGS) -o $@ $<
$(AS_POST_PROCESS)
endef

ifeq ($(MAKE_VERSION),3.81) 
.SECONDEXPANSION:

$(APP_OBJS_C): $(CONFIG_OBJ_DIR)/%.o: $$(call adjust-path-mixed,%.c)
	$(compile.c)

$(APP_OBJS_CPP): $(CONFIG_OBJ_DIR)/%.o: $$(call adjust-path-mixed,%.cpp)
	$(compile.cpp)

$(APP_OBJS_CC): $(CONFIG_OBJ_DIR)/%.o: $$(call adjust-path-mixed,%.cc)
	$(compile.cpp)

$(APP_OBJS_CXX): $(CONFIG_OBJ_DIR)/%.o: $$(call adjust-path-mixed,%.cxx)
	$(compile.cpp)

$(APP_OBJS_S): $(CONFIG_OBJ_DIR)/%.o: $$(call adjust-path-mixed,%.S)
	$(compile.s)

$(APP_OBJS_SS): $(CONFIG_OBJ_DIR)/%.o: $$(call adjust-path-mixed,%.s)
	$(compile.s)

endif # MAKE_VERSION != 3.81

$(CONFIG_OBJ_DIR)/%.o: %.c
	$(compile.c)

$(CONFIG_OBJ_DIR)/%.o: %.cpp
	$(compile.cpp)

$(CONFIG_OBJ_DIR)/%.o: %.cc
	$(compile.cpp)

$(CONFIG_OBJ_DIR)/%.o: %.cxx
	$(compile.cpp)

$(CONFIG_OBJ_DIR)/%.o: %.S
	$(compile.s)

$(CONFIG_OBJ_DIR)/%.o: %.s
	$(compile.s)


#------------------------------------------------------------------------------
#                     PATTERN RULES TO INTERMEDIATE FILES
#------------------------------------------------------------------------------

$(CONFIG_OBJ_DIR)/%.s: %.c
	@$(ECHO) Info: Compiling $< to $@
	@$(MKDIR) $(@D)
	$(CC) -S $(APP_CPPFLAGS) $(APP_CFLAGS) -o $@ $<

$(CONFIG_OBJ_DIR)/%.s: %.cpp
	@$(ECHO) Info: Compiling $< to $@
	@$(MKDIR) $(@D)
	$(CXX) -S $(APP_CPPFLAGS) $(APP_CXXFLAGS) $(APP_CFLAGS) -o $@ $<

$(CONFIG_OBJ_DIR)/%.s: %.cc
	@$(ECHO) Info: Compiling $< to $@
	@$(MKDIR) $(@D)
	$(CXX) -S $(APP_CPPFLAGS) $(APP_CXXFLAGS) $(APP_CFLAGS) -o $@ $<

$(CONFIG_OBJ_DIR)/%.s: %.cxx
	@$(ECHO) Info: Compiling $< to $@
	@$(MKDIR) $(@D)
	$(CXX) -S $(APP_CPPFLAGS) $(APP_CXXFLAGS) $(APP_CFLAGS) -o $@ $<

$(CONFIG_OBJ_DIR)/%.i: %.c
	@$(ECHO) Info: Compiling $< to $@
	@$(MKDIR) $(@D)
	$(CC) -E $(APP_CPPFLAGS) $(APP_CFLAGS) -o $@ $<

$(CONFIG_OBJ_DIR)/%.i: %.cpp
	@$(ECHO) Info: Compiling $< to $@
	@$(MKDIR) $(@D)
	$(CXX) -E $(APP_CPPFLAGS) $(APP_CXXFLAGS) $(APP_CFLAGS) -o $@ $<

$(CONFIG_OBJ_DIR)/%.i: %.cc
	@$(ECHO) Info: Compiling $< to $@
	@$(MKDIR) $(@D)
	$(CXX) -E $(APP_CPPFLAGS) $(APP_CXXFLAGS) $(APP_CFLAGS) -o $@ $<

$(CONFIG_OBJ_DIR)/%.i: %.cxx
	@$(ECHO) Info: Compiling $< to $@
	@$(MKDIR) $(@D)
	$(CXX) -E $(APP_CPPFLAGS) $(APP_CXXFLAGS) $(APP_CFLAGS) -o $@ $<


#------------------------------------------------------------------------------
#                        TARGET RULES
#------------------------------------------------------------------------------

.PHONY : help
help :
	@$(ECHO) "Summary of Makefile targets"
	@$(ECHO) "  Build targets:"
	@$(ECHO) "    all (default)     - Application and all libraries (including BSP)"
	@$(ECHO) "    bsp               - Just the BSP"
	@$(ECHO) "    libs              - All libraries (including BSP)"
	@$(ECHO) "    flash             - All flash files"
	@$(ECHO) "    mem_init_generate - All memory initialization files"
	@$(ECHO)
	@$(ECHO) "  Clean targets:"
	@$(ECHO) "    clean_all         - Application and all libraries (including BSP)"
	@$(ECHO) "    clean             - Just the application"
	@$(ECHO) "    clean_bsp         - Just the BSP"
	@$(ECHO) "    clean_libs        - All libraries (including BSP)"
	@$(ECHO)
	@$(ECHO) "  Run targets:"
	@$(ECHO) "    download-elf      - Download and run your elf executable"
	@$(ECHO) "    program-flash     - Program flash contents to the board"

# Handy rule to skip making libraries and just make application.
.PHONY : app
app : $(ELF)

ifeq ($(CREATE_OBJDUMP), 1)
app : $(OBJDUMP_NAME)
endif

ifeq ($(CREATE_ELF_DERIVED_FILES),1)
app : elf_derived_files
endif

.PHONY: elf_derived_files
elf_derived_files: default_mem_init

# Handy rule for making just the BSP.
.PHONY : bsp
bsp :
	@$(ECHO) Info: Building $(BSP_ROOT_DIR)
	@$(MAKE) --no-print-directory -C $(BSP_ROOT_DIR)


# Make sure all makeable libraries (including the BSP) are up-to-date.
LIB_TARGETS := $(patsubst %,%-recurs-make-lib,$(MAKEABLE_LIBRARY_ROOT_DIRS))

.PHONY : libs
libs : $(LIB_TARGETS)

ifneq ($(strip $(LIB_TARGETS)),)
$(LIB_TARGETS): %-recurs-make-lib:
	@$(ECHO) Info: Building $*
	$(MAKE) --no-print-directory -C $*
endif

ifneq ($(strip $(APP_LDDEPS)),)
$(APP_LDDEPS): libs
	@true
endif

# Rules to force your project to rebuild or relink
# .force_relink file will cause any application that depends on this project to relink
# .force_rebuild file will cause this project to rebuild object files
# .force_rebuild_all file will cause this project and any project that depends on this project to rebuild object files

FORCE_RELINK_DEP  := .force_relink
FORCE_REBUILD_DEP := .force_rebuild
FORCE_REBUILD_ALL_DEP := .force_rebuild_all
FORCE_REBUILD_DEP_LIST := $(CONFIG_OBJ_DIR)/$(FORCE_RELINK_DEP) $(CONFIG_OBJ_DIR)/$(FORCE_REBUILD_DEP) $(FORCE_REBUILD_ALL_DEP)

$(FORCE_REBUILD_DEP_LIST):

$(APP_OBJS): $(wildcard $(CONFIG_OBJ_DIR)/$(FORCE_REBUILD_DEP)) $(wildcard $(addsuffix /$(FORCE_REBUILD_ALL_DEP), . $(ALT_LIBRARY_DIRS)))

$(ELF): $(wildcard $(addsuffix /$(FORCE_RELINK_DEP), $(CONFIG_OBJ_DIR) $(ALT_LIBRARY_DIRS)))


# Clean just the application.
.PHONY : clean
ifeq ($(CREATE_ELF_DERIVED_FILES),1)
clean : clean_elf_derived_files
endif

clean :
	@$(RM) -r $(ELF) $(OBJDUMP_NAME) $(LINKER_MAP_NAME) $(OBJ_ROOT_DIR) $(RUNTIME_ROOT_DIR) $(FORCE_REBUILD_DEP_LIST)
	@$(ECHO) [$(APP_NAME) clean complete]

# Clean just the BSP.
.PHONY : clean_bsp
clean_bsp :
	@$(ECHO) Info: Cleaning $(BSP_ROOT_DIR)
	@$(MAKE) --no-print-directory -C $(BSP_ROOT_DIR) clean

# Clean all makeable libraries including the BSP.
LIB_CLEAN_TARGETS := $(patsubst %,%-recurs-make-clean-lib,$(MAKEABLE_LIBRARY_ROOT_DIRS))

.PHONY : clean_libs
clean_libs : $(LIB_CLEAN_TARGETS)

ifneq ($(strip $(LIB_CLEAN_TARGETS)),)
$(LIB_CLEAN_TARGETS): %-recurs-make-clean-lib:
	@$(ECHO) Info: Cleaning $*
	$(MAKE) --no-print-directory -C $* clean
endif

.PHONY: clean_elf_derived_files
clean_elf_derived_files: mem_init_clean

# Clean application and all makeable libraries including the BSP.
.PHONY : clean_all
clean_all : clean mem_init_clean clean_libs

# Include the dependency files unless the make goal is performing a clean
# of the application.
ifneq ($(firstword $(MAKECMDGOALS)),clean)
ifneq ($(firstword $(MAKECMDGOALS)),clean_all)
-include $(APP_DEPS)
endif
endif

.PHONY : download-elf
download-elf : $(ELF)
	@if [ "$(DOWNLOAD)" = "none" ]; \
	then \
		$(ECHO) Downloading $(ELF) not supported; \
	else \
		$(ECHO) Info: Downloading $(ELF); \
		$(DOWNLOAD) --go --cpu_name=$(CPU_NAME) $(DOWNLOAD_CABLE_FLAG) $(SOPC_SYSID_FLAG) $(DOWNLOAD_JDI_FLAG) $(WRITE_GMON_OPTION) $(ELF); \
	fi

# Delete the target of a rule if it has changed and its commands exit
# with a nonzero exit status.
.DELETE_ON_ERROR:

# Rules for flash programming commands
PROGRAM_FLASH_SUFFIX := -program
PROGRAM_FLASH_TARGET := $(addsuffix $(PROGRAM_FLASH_SUFFIX), $(FLASH_FILES))

.PHONY : program-flash
program-flash : $(PROGRAM_FLASH_TARGET)

.PHONY : $(PROGRAM_FLASH_TARGET)
$(PROGRAM_FLASH_TARGET) : flash
	@if [ "$(FLASHPROG)" = "none" ]; \
	then \
		$(ECHO) Programming flash not supported; \
	else \
		$(ECHO) Info: Programming $(basename $@).flash; \
		if [ -z "$($(basename $@)_EPCS_FLAGS)" ]; \
		then \
			$(ECHO) $(FLASHPROG) $(SOPC_SYSID_FLAG) --base=$($(basename $@)_START) $(basename $@).flash; \
			$(FLASHPROG) $(DOWNLOAD_CABLE_FLAG) $(SOPC_SYSID_FLAG) --base=$($(basename $@)_START) $(basename $@).flash; \
		else \
			$(ECHO) $(FLASHPROG) $(SOPC_SYSID_FLAG) --epcs --base=$($(basename $@)_START) $(basename $@).flash; \
			$(FLASHPROG) $(DOWNLOAD_CABLE_FLAG) $(SOPC_SYSID_FLAG) --epcs --base=$($(basename $@)_START) $(basename $@).flash; \
		fi \
	fi


# Rules for simulating with an HDL Simulator [QSYS only]
ifeq ($(QSYS),1)
#Create a top level modelsim script load_sim.tcl to source generate msim_setup.tcl and copy mem initialization files
CREATE_TOP_SIM_SCRIPT := alt-create-top-sim-script

ifeq ($(VSIM),)
VSIM_EXE := "$(if $(VSIM_DIR),$(VSIM_DIR)/,)vsim"
ifeq ($(ENABLE_VSIM_GUI),1)
VSIM := $(VSIM_EXE) -gui
else
VSIM := $(VSIM_EXE) -c
endif # ENABLE_VSIM_GUI == 1
endif # VSIM not set

ifeq ($(SPD),)
ifneq ($(ABS_QUARTUS_PROJECT_DIR),)
ifneq ($(SOPC_NAME),)
SPD_LOCATION = $(ABS_QUARTUS_PROJECT_DIR)/$(SOPC_NAME)_tb/$(SOPC_NAME)_tb/$(SOPC_NAME)_tb.spd
LEGACY_SPD_LOCATION = $(ABS_QUARTUS_PROJECT_DIR)/$(SOPC_NAME)_tb.spd
SPD = $(if $(wildcard $(SPD_LOCATION)),$(SPD_LOCATION),$(LEGACY_SPD_LOCATION))
endif # SOPC_NAME set
endif # ABS_QUARTUS_PROJECT_DIR set
endif # SPD == empty string


ifeq ($(LOAD_SIM_SCRIPT),)
SIM_SCRIPT_DIR := $(RUNTIME_ROOT_DIR)/sim
LOAD_SIM_SCRIPT := $(SIM_SCRIPT_DIR)/mentor/load_sim.tcl
endif # LOAD_SIM_SCRIPT == empty string

ifeq ($(MAKE_VERSION),3.81)
ABS_MEM_INIT_DESCRIPTOR_FILE := $(abspath $(MEM_INIT_DESCRIPTOR_FILE))
else
ABS_MEM_INIT_DESCRIPTOR_FILE := $(call adjust-path-mixed,$(shell pwd))/$(MEM_INIT_DESCRIPTOR_FILE)
endif

$(LOAD_SIM_SCRIPT): $(SPD) $(MEM_INIT_DESCRIPTOR_FILE)
ifeq ($(SPD),)
	$(error No SPD file specified. Ensure QUARTUS_PROJECT_DIR variable is set)
endif
	@$(MKDIR) $(SIM_SCRIPT_DIR)
	$(CREATE_TOP_SIM_SCRIPT) --spd=$(SPD) --mem-init-spd=$(abspath $(MEM_INIT_DESCRIPTOR_FILE)) --output-directory=$(SIM_SCRIPT_DIR)

VSIM_COMMAND = \
	cd $(dir $(LOAD_SIM_SCRIPT)) && \
	$(VSIM) -do "do $(notdir $(LOAD_SIM_SCRIPT)); ld; $(if $(VSIM_RUN_TIME),run ${VSIM_RUN_TIME};quit;)"

.PHONY: sim
sim: $(LOAD_SIM_SCRIPT) mem_init_generate
ifeq ($(LOAD_SIM_SCRIPT),)
	$(error LOAD_SIM_SCRIPT not set)
endif
	$(VSIM_COMMAND)

endif # QSYS == 1




#------------------------------------------------------------------------------
#                         ELF TARGET RULE
#------------------------------------------------------------------------------
# Rule for constructing the executable elf file.
$(ELF) : $(APP_OBJS) $(LINKER_SCRIPT) $(APP_LDDEPS)
	@$(ECHO) Info: Linking $@
	$(LD) $(APP_LDFLAGS) $(APP_CFLAGS) -o $@ $(filter-out $(CRT0),$(APP_OBJS)) $(APP_LIBS) $(APP_BSP_DEP_LIBS)
ifneq ($(DISABLE_ELFPATCH),1)
	$(ELFPATCH) $@ $(ELF_PATCH_FLAG)
endif
ifneq ($(DISABLE_STACKREPORT),1)
	@bash -c "$(STACKREPORT) $@"
endif

$(OBJDUMP_NAME) : $(ELF)
	@$(ECHO) Info: Creating $@
	$(OBJDUMP) $(OBJDUMP_FLAGS) $< >$@

# Rule for printing the name of the elf file
.PHONY: print-elf-name
print-elf-name:
	@$(ECHO) $(ELF)


