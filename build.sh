#!/bin/bash
set -e
npm i @capacitor/core@6 @capacitor/cli@6 @capacitor/android@6 @capacitor/status-bar@6 @capacitor/browser@6 three@0.128.0
mkdir -p www/lib
cp node_modules/three/build/three.min.js www/lib/
cp node_modules/three/examples/js/loaders/GLTFLoader.js www/lib/
npx cap add android
sed -i 's/<activity/<activity android:screenOrientation="sensorLandscape"/' android/app/src/main/AndroidManifest.xml
mkdir -p android/app/src/main/java/com/f35/game
cat > android/app/src/main/java/com/f35/game/MainActivity.java <<'JAVA'
package com.f35.game;
import android.os.Bundle;
import android.view.View;
import android.view.WindowManager;
import com.getcapacitor.BridgeActivity;
public class MainActivity extends BridgeActivity {
  @Override public void onCreate(Bundle b) {
    super.onCreate(b);
    getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
    if (android.os.Build.VERSION.SDK_INT >= 28) {
      getWindow().getAttributes().layoutInDisplayCutoutMode = WindowManager.LayoutParams.LAYOUT_IN_DISPLAY_CUTOUT_MODE_SHORT_EDGES;
    }
    hide();
  }
  @Override public void onWindowFocusChanged(boolean f) { super.onWindowFocusChanged(f); if (f) hide(); }
  private void hide() {
    getWindow().getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY | View.SYSTEM_UI_FLAG_FULLSCREEN | View.SYSTEM_UI_FLAG_HIDE_NAVIGATION | View.SYSTEM_UI_FLAG_LAYOUT_STABLE | View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION | View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN);
  }
}
JAVA
npx cap sync android
cd android
chmod +x gradlew
./gradlew assembleDebug
