package io.xpush;

import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.util.Log;
import android.view.View;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.uimanager.UIManagerModule;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;

public class ScreenshotModule extends ReactContextBaseJavaModule {

    private static final String TAG = ScreenshotModule.class.getSimpleName();


    private static final String REACT_CLASS = "ScrollingScreenshot";

    private ReactContext mReactContext;

    private Callback callback;
    public ScreenshotModule(ReactApplicationContext reactContext) {
        super(reactContext);
        mReactContext = reactContext;
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    @ReactMethod
    public void takeScreenshot(ReadableMap map, Callback callback) {
        UIManagerModule uiManager = getReactApplicationContext().getNativeModule(UIManagerModule.class);
        View view = uiManager.findSubviewIn();
    }

    private String screenshot(View view) {

        String result = "";

        try {
            view.measure(View.MeasureSpec.makeMeasureSpec(View.MeasureSpec.UNSPECIFIED, View.MeasureSpec.UNSPECIFIED), View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED));
            view.layout(0, 0, view.getMeasuredWidth(), view.getMeasuredHeight());
            view.setDrawingCacheEnabled(true);
            view.buildDrawingCache();

            Bitmap bm = Bitmap.createBitmap(view.getMeasuredWidth(), view.getMeasuredHeight(), Bitmap.Config.ARGB_8888);

            Canvas bigcanvas = new Canvas(bm);
            Paint paint = new Paint();
            int iHeight = bm.getHeight();
            bigcanvas.drawBitmap(bm, 0, iHeight, paint);
            view.draw(bigcanvas);

            FileOutputStream fos;
            File storeDir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES);

            String filePath = storeDir.getAbsolutePath()+"/"+"temp.jpg";
            fos = new FileOutputStream(filePath);

            //Bitmap captureView = b.g
            bm.compress(Bitmap.CompressFormat.JPEG, 80, fos);

            result = filePath;

            File f = new File( filePath );
            Uri contentUri = Uri.fromFile(f);
            result = contentUri.toString();

            Intent mediaScanIntent = new Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE);
            mediaScanIntent.setData(contentUri);
            mReactContext.sendBroadcast(mediaScanIntent);

        } catch (FileNotFoundException e) {
            Log.d("FileNotFoundException:", e.getMessage());
        } catch ( Exception e ){
            e.printStackTrace();
        }

        return result;
    }
}