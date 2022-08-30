SKIPMOUNT=false
PROPFILE=false
POSTFSDATA=false
LATESTARTSERVICE=false

REPLACE="
"

print_modname() {
  ui_print ""
  ui_print "•••••••••••••••••••••••"
  ui_print "    Moto Experience"
  ui_print "•••••••••••••••••••••••"
  ui_print ""
  ui_print "• Module by Syoker"
  ui_print ""
}

android_check() {
 if [[ $API < 29 ]]; then
   ui_print "• Sorry, you need Android 10 or later to use this module."
   ui_print ""
   sleep 2
   exit 1
 fi
}

volume_keytest() {
  ui_print "• Volume Key Test"
  ui_print "  Please press any key volume:"
  (/system/bin/getevent -lc 1 2>&1 | /system/bin/grep VOLUME | /system/bin/grep " DOWN" > "$TMPDIR"/events) || return 1
  return 0
}

volume_key() {
  while (true); do
    /system/bin/getevent -lc 1 2>&1 | /system/bin/grep VOLUME | /system/bin/grep " DOWN" > "$TMPDIR"/events
      if $(cat "$TMPDIR"/events 2>/dev/null | /system/bin/grep VOLUME >/dev/null); then
          break
      fi
  done
  if $(cat "$TMPDIR"/events 2>/dev/null | /system/bin/grep VOLUMEUP >/dev/null); then
      return 1
  else
      return 0
  fi
}

remove-motowalls() {
  rm $MODPATH/system/system_ext/priv-app/MotoLiveWallpaper3
  rm $MODPATH/system/system_ext/etc/permissions/afw-com.motorola.livewallpaper.xml
  rm $MODPATH/system/system_ext/etc/permissions/feature-com.motorola.motolivewallpaper3.xml
  rm $MODPATH/system/system_ext/sysconfig/hiddenapi-whitelist-com.motorola.livewallpaper.xml
  rm $MODPATH/system/product/app/MotoLiveWallpaper
  rm $MODPATH/system/product/app/MotoLiveWallpaper2
  rm $MODPATH/system/product/app/MotoWalls
  rm $MODPATH/system/product/etc/permissions/feature-com.motorola.motolivewallpaper.support.astro.xml
  rm $MODPATH/system/product/etc/permissions/feature-com.motorola.motolivewallpaper.support.racer.xml
  rm $MODPATH/system/product/etc/permissions/feature-com.motorola.motolivewallpaper.support.titan.xml
  rm $MODPATH/system/product/etc/permissions/feature-com.motorola.motolivewallpaper.xml
  rm $MODPATH/system/product/etc/permissions/feature-com.motorola.motolivewallpaper3.xml
  rm $MODPATH/system/product/etc/sysconfig/hiddenapi-whitelist-com.motorola.livewallpaper.xml
  rm $MODPATH/system/product/priv-app/MotoLiveWallpaper3
}

remove-motowidget() {
  rm $MODPATH/system/etc/fonts.xml
  rm $MODPATH/system/fonts
  rm $MODPATH/system/product/app/TimeWeather
  rm $MODPATH/system/product/etc/permissions/com.motorola.timeweatherwidget.xml
  rm $MODPATH/system/product/etc/sysconfig/hiddenapi-whitelist-com.motorola.timeweatherwidget.xml
  rm $MODPATH/system/product/overlay/FontArchivoSemiBold
  rm $MODPATH/system/product/overlay/FontBarlowSource
  rm $MODPATH/system/product/overlay/FontExo2RegularSource
  rm $MODPATH/system/product/overlay/FontNotoSerifSource
  rm $MODPATH/system/product/overlay/FontQuicksandSource
  rm $MODPATH/system/product/overlay/FontRobotoSlabRegular
}

on_install() {

  android_check

  if volume_keytest; then

    ui_print "  Key test function complete"
    ui_print ""
    sleep 2
  
    unzip -o "$ZIPFILE" 'system/*' -d $MODPATH >&2
    
    ui_print "• Do you want to install Moto Actions?"
    ui_print "  Volume up(+): Yes"
    ui_print "  Volume down(-): No"

    SELECT=volume_key

    if "$SELECT"; then
      ui_print "  Removing..."
      ui_print ""
      rm $MODPATH/system/priv-app/MotoActions.apk
      sleep 1
    else
      ui_print "  Installing..."
      sleep 1
      ui_print "  Done"
      ui_print ""
    fi

    ui_print "• Do you want to install Moto Bootanimation?"
    ui_print "  Volume up(+): Yes"
    ui_print "  Volume down(-): No"

    if "$SELECT"; then
      ui_print "  Removing Moto Bootanimation"
      ui_print ""
      sleep 1
    else
      ui_print "  Which bootanimation do you want?"
      ui_print "  Volume up(+): Install bootanimation"
      ui_print "  Volume down(-): Other bootanimation"
      ui_print ""
      while (true); do
        ui_print "  1 - Moto Bootanimation 2013"
        if "$SELECT"; then
          ui_print "  2 - Moto Bootanimation 2020"
          if "$SELECT"; then
            ui_print "  3 - Moto Bootanimation 2021"
            if "$SELECT"; then
              ui_print ""
            else
              ui_print "      Installing..."
              mkdir -p $MODPATH/system/product/media
              cp -f $MODPATH/system/product/media/motobootanimation30.zip $MODPATH/system/product/media/bootanimation.zip
              ui_print "      Done"
              ui_print ""
              break
            fi
          else
            ui_print "      Installing..."
            mkdir -p $MODPATH/system/product/media
            cp -f $MODPATH/system/product/media/motobootanimation29.zip $MODPATH/system/product/media/bootanimation.zip
            ui_print "      Done"
            ui_print ""
            break
          fi
        else
          ui_print "      Installing..."
          mkdir -p $MODPATH/system/product/media
          cp -f $MODPATH/system/product/media/motobootanimation17.zip $MODPATH/system/product/media/bootanimation.zip
          ui_print "      Done"
          ui_print ""
          break
        fi
      done
    fi
    rm $MODPATH/system/product/media/motobootanimation17.zip
    rm $MODPATH/system/product/media/motobootanimation29.zip
    rm $MODPATH/system/product/media/motobootanimation30.zip

    ui_print "• Do you want to install Moto Walls?"
    ui_print "  Volume up(+): Yes"
    ui_print "  Volume down(-): No"

    if "$SELECT"; then
      ui_print "  Removing..."
      ui_print ""
      remove-motowalls
      sleep 1
    else
      ui_print "  Installing..."
      sleep 1
      ui_print "  Done"
      ui_print ""
    fi

    ui_print "• Do you want to install Moto Clock Widget?"
    ui_print "  Volume up(+): Yes"
    ui_print "  Volume down(-): No"

    if "$SELECT"; then
      ui_print "  Removing..."
      ui_print ""
      remove-motowidget
      sleep 1
    else
      ui_print "  Installing..."
      sleep 1
      ui_print "  Done"
      ui_print ""
    fi
    
  else
    ui_print "  You have not pressed any key, aborting installation."
    ui_print ""
    sleep 2
    exit 1
  fi
  
  ui_print "- Deleting package cache"
  rm -rf /data/system/package_cache/*
}

set_permissions() {
  set_perm_recursive $MODPATH 0 0 0755 0644
}