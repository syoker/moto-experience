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
  if $(timeout 9 /system/bin/getevent -lc 1 2>&1 | /system/bin/grep "VOLUME" | /system/bin/grep "DOWN" > $TMPDIR/events); then
    return 0
  else
    [[ "$SEL" == "143" ]] && abort "  You have not pressed any key, aborting installation." || return 1
  fi
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
  volume_keytest

  unzip -o "$ZIPFILE" 'system/*' -d $MODPATH >&2

  ui_print ""
  ui_print "• Do you want to install Moto Actions?"
  ui_print "  Volume up(+): Yes"
  ui_print "  Volume down(-): No"

  SELECT=volume_key

  if "$SELECT"; then
    ui_print "  Removing Moto Actions"
    ui_print ""
    rm $MODPATH/system/motoactions.zip
    sleep 1
  else
    ui_print "  Installing Moto Actions"
    unzip $MODPATH/system/motoactions.zip -d $MODPATH/system/priv-app/
    ui_print "  Done"
    ui_print ""
    rm $MODPATH/system/motoactions.zip
    sleep 1
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
            cp -f $MODPATH/system/motobootanimation30.zip $MODPATH/system/product/media/bootanimation.zip
            ui_print "      Done"
            ui_print ""
            break
          fi
        else
          ui_print "      Installing..."
          cp -f $MODPATH/system/motobootanimation29.zip $MODPATH/system/product/media/bootanimation.zip
          ui_print "      Done"
          ui_print ""
          break
        fi
      else
        ui_print "      Installing..."
        cp -f $MODPATH/system/motobootanimation17.zip $MODPATH/system/product/media/bootanimation.zip
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
    ui_print "  Removing Moto Walls"
    ui_print ""
    rm $MODPATH/system/motowalls.zip
    sleep 1
  else
    ui_print "  Installing Moto Walls"
    unzip $MODPATH/system/motowalls.zip -d $MODPATH/system/
    ui_print "  Done"
    ui_print ""
    rm $MODPATH/system/motowalls.zip
    sleep 1
  fi

  ui_print "• Do you want to install Moto Widget?"
  ui_print "  Volume up(+): Yes"
  ui_print "  Volume down(-): No"

  if "$SELECT"; then
    ui_print "  Removing Moto Widget"
    ui_print ""
    rm $MODPATH/system/motowidget.zip
    sleep 1
  else
    ui_print "  Installing Moto Widget"
    unzip $MODPATH/system/motowidget.zip -d $MODPATH/system/
    ui_print "  Done"
    ui_print ""
    rm $MODPATH/system/motowidget.zip
    sleep 1
  fi
  
  ui_print "- Deleting package cache"
  rm -rf /data/system/package_cache/*
}

set_permissions() {
  set_perm_recursive $MODPATH 0 0 0755 0644
}