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

  sleep 2
}

online_check() {

  CHECK=$($MODPATH/addon/curl -s -I http://www.google.com --connect-timeout 5 | grep "ok")
  
  if [ ! -z "$CHECK" ]; then
    ui_print "• Network is Online"
    sleep 1
    ui_print ""
  else
    ui_print ""
    ui_print "• Network is Offline"
    ui_print "  If you have the offline version, select force install."
    ui_print "  If you are using the online version, select abort and check"
    ui_print "  your internet connection."
    ui_print "  If you think this is a bug in the module, select force install."
    ui_print ""
    ui_print "  Volume up(+): Force install"
    ui_print "  Volume down(-): Abort"
    
    SELECT=volume_key

    if "$SELECT"; then
      ui_print "  Aborting installation..."
      exit 1
    else
      ui_print "  Forcing installation..."
    fi
  fi
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
  (timeout 5 /system/bin/getevent -lc 1 2>&1 | /system/bin/grep VOLUME | /system/bin/grep " DOWN" > "$TMPDIR"/events) || return 1
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

on_install() {

  android_check

  if volume_keytest; then

    ui_print "  Key test function complete"
    ui_print ""
    sleep 2

    online_check
  
    unzip -o "$ZIPFILE" 'system/*' -d $MODPATH >&2

    ui_print "• Do you want to install Moto Actions?"
    ui_print "  Volume up(+): Yes"
    ui_print "  Volume down(-): No"

    SELECT=volume_key

    if "$SELECT"; then
      ui_print "  Removing..."
      ui_print ""
      rm $MODPATH/system/motoactions.apk
      sleep 1
    else
      ui_print "  Installing..."
      mkdir $MODPATH/system/priv-app/
      cp -f $MODPATH/system/motoactions.apk $MODPATH/system/priv-app/motoactions.apk
      rm $MODPATH/system/motoactions.apk
      sleep 1
      ui_print "  Done"
      ui_print ""
    fi

    ui_print "• Do you want to install Moto Bootanimation?"
    ui_print "  Volume up(+): Yes"
    ui_print "  Volume down(-): No"

    if "$SELECT"; then
      ui_print "  Removing..."
      ui_print ""
      sleep 1
    else
      ui_print "  Which bootanimation do you want?"
      ui_print "  Volume up(+): Install bootanimation"
      ui_print "  Volume down(-): Another bootanimation"
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
              cp -f $MODPATH/system/motobootanimation30.zip $MODPATH/system/product/media/bootanimation.zip
              sleep 1
              ui_print "      Done"
              ui_print ""
              break
            fi
          else
            ui_print "      Installing..."
            mkdir -p $MODPATH/system/product/media
            cp -f $MODPATH/system/motobootanimation29.zip $MODPATH/system/product/media/bootanimation.zip
            sleep 1
            ui_print "      Done"
            ui_print ""
            break
          fi
        else
          ui_print "      Installing..."
          mkdir -p $MODPATH/system/product/media
          cp -f $MODPATH/system/motobootanimation17.zip $MODPATH/system/product/media/bootanimation.zip
          sleep 1
          ui_print "      Done"
          ui_print ""
          break
        fi
      done
    fi
    rm $MODPATH/system/motobootanimation17.zip
    rm $MODPATH/system/motobootanimation29.zip
    rm $MODPATH/system/motobootanimation30.zip

    ui_print "• Do you want to install Moto Walls?"
    ui_print "  Volume up(+): Yes"
    ui_print "  Volume down(-): No"

    if "$SELECT"; then
      ui_print "  Removing..."
      rm $MODPATH/system/motowalls.tar.xz
      sleep 1
      ui_print ""
    else
      ui_print "  Installing..."
      tar -xf $MODPATH/system/motowalls.tar.xz -C $MODPATH/system/
      rm $MODPATH/system/motowalls.tar.xz
      sleep 1
      ui_print "  Done"
      ui_print ""
    fi

    ui_print "• Do you want to install Moto Clock Widget?"
    ui_print "  Volume up(+): Yes"
    ui_print "  Volume down(-): No"

    if "$SELECT"; then
      ui_print "  Removing..."
      rm $MODPATH/system/motowidget.tar.xz
      sleep 1
      ui_print ""
    else
      ui_print "  Installing..."
      tar -xf $MODPATH/system/motowidget.tar.xz -C $MODPATH/system/
      rm $MODPATH/system/motowidget.tar.xz
      sleep 1
      ui_print "  Done"
      ui_print ""
    fi

    ui_print "• Do you want to install Moto Camera 2?"
    ui_print "  Volume up(+): Yes"
    ui_print "  Volume down(-): No"

    if "$SELECT"; then
      ui_print "  Removing..."
      rm $MODPATH/system/motocamera2.tar.xz
      rm $MODPATH/system/motocamera2ai.tar.xz
      rm $MODPATH/system/motocamera2props.tar.xz
      rm $MODPATH/system/motocamera2tunner.tar.xz
      rm $MODPATH/system/motophotoeditor.tar.xz
      sleep 1
      ui_print ""
    else
      ui_print "  Installing..."
      tar -xf $MODPATH/system/motocamera2.tar.xz -C $MODPATH/system/
      tar -xf $MODPATH/system/motocamera2ai.tar.xz -C $MODPATH/system/
      tar -xf $MODPATH/system/motocamera2props.tar.xz -C $MODPATH/system/
      tar -xf $MODPATH/system/motocamera2tunner.tar.xz -C $MODPATH/system/
      tar -xf $MODPATH/system/motophotoeditor.tar.xz -C $MODPATH/system/
      rm $MODPATH/system/motocamera2.tar.xz
      rm $MODPATH/system/motocamera2ai.tar.xz
      rm $MODPATH/system/motocamera2props.tar.xz
      rm $MODPATH/system/motocamera2tunner.tar.xz
      rm $MODPATH/system/motophotoeditor.tar.xz
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