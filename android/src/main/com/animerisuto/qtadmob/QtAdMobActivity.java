package com.animerisuto.qtadmob;


import android.content.Context;
import android.os.Bundle;
import android.view.Gravity;
import android.view.KeyEvent;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.FrameLayout;
import android.widget.RelativeLayout;

import com.google.android.gms.ads.AdListener;
import com.google.android.gms.ads.AdRequest;
import com.google.android.gms.ads.AdSize;
import com.google.android.gms.ads.AdView;
import com.google.android.gms.ads.InterstitialAd;
import com.google.android.gms.ads.MobileAds;

import android.util.Log;


import org.qtproject.qt5.android.bindings.QtActivity;
//import org.qtproject.utils.HyPush.push.Pushbots;

import java.util.ArrayList;

//import io.fabric.sdk.android.Fabric;


public class QtAdMobActivity extends QtActivity {
    private static String TAG = QtAdMobActivity.class.getSimpleName();

    private static WebView w;
    private ViewGroup m_ViewGroup;
    private AdView m_AdBannerView;
    private InterstitialAd m_AdInterstitial;
    private boolean m_IsAdBannerShowed = false;
    private boolean m_IsAdInterstitiaNeedToShow = false;
    private boolean m_IsAdBannerLoaded = false;
    private boolean m_IsAdInterstitialLoaded = false;
    private ArrayList<String> m_TestDevices = new ArrayList<String>();
    private int m_AdBannerWidth = 0;
    private int m_AdBannerHeight = 0;
    private int m_StatusBarHeight = 0;

    public static void loadWebView(final String url) {

        w.post(new Runnable() {
            @Override
            public void run() {
                w.loadUrl(url);
            }
        });

    }

    public static void HyPushInit(Context ctx, String app_id, String sender_id, String hy_app_key, String logLevelString) {

        // Pushbots.sharedInstance().init(ctx,app_id,sender_id,hy_app_key,logLevelString);

    }

    public void initializeAppId(final String appId) {
        Log.d(TAG, "initializeAppId : " + appId);
        MobileAds.initialize(this, appId);
    }

    private int GetStatusBarHeight() {
        int result = 0;
        int resourceId = getResources().getIdentifier("status_bar_height", "dimen", "android");
        if (resourceId > 0) {
            result = getResources().getDimensionPixelSize(resourceId);
        }
        return result;
    }

    public void SetAdBannerUnitId(final String adId) {
        runOnUiThread(new Runnable() {
            public void run() {
                m_AdBannerView.setAdUnitId(adId);
            }
        });
    }

    public void SetAdBannerSize(final int size) {
        final QtAdMobActivity self = this;
        runOnUiThread(new Runnable() {
            public void run() {
                AdSize adSize = AdSize.BANNER;
                switch (size) {
                    case 0:
                        adSize = AdSize.BANNER;
                        break;
                    case 1:
                        adSize = AdSize.FULL_BANNER;
                        break;
                    case 2:
                        adSize = AdSize.LARGE_BANNER;
                        break;
                    case 3:
                        adSize = AdSize.MEDIUM_RECTANGLE;
                        break;
                    case 4:
                        adSize = AdSize.SMART_BANNER;
                        break;
                    case 5:
                        adSize = AdSize.WIDE_SKYSCRAPER;
                        break;
                }
                ;

                m_AdBannerView.setAdSize(adSize);
                m_AdBannerWidth = adSize.getWidthInPixels(self);
                m_AdBannerHeight = adSize.getHeightInPixels(self);
            }
        });
    }

    public void SetAdBannerPosition(final int x, final int y) {
        runOnUiThread(new Runnable() {
            public void run() {
                FrameLayout.LayoutParams layoutParams = new FrameLayout.LayoutParams(FrameLayout.LayoutParams.WRAP_CONTENT,
                        FrameLayout.LayoutParams.WRAP_CONTENT);
                m_AdBannerView.setLayoutParams(layoutParams);
                m_AdBannerView.setX(x);
                //  m_AdBannerView.setY(y + m_StatusBarHeight);
            }
        });
    }

    public void AddAdTestDevice(final String deviceId) {
        runOnUiThread(new Runnable() {
            public void run() {
                m_TestDevices.add(deviceId);
            }
        });
    }

    public boolean IsAdBannerShowed() {
        return m_IsAdBannerShowed;
    }

    public boolean IsAdBannerLoaded() {
        return m_IsAdBannerLoaded;
    }

    public int GetAdBannerWidth() {
        return m_AdBannerWidth;
    }

    public int GetAdBannerHeight() {
        return m_AdBannerHeight;
    }

    public void ShowAdBanner() {
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                if (IsAdBannerShowed()) {
                    return;
                }

                if (!IsAdBannerLoaded()) {
                    AdRequest.Builder adRequest = new AdRequest.Builder();
                    adRequest.addTestDevice(AdRequest.DEVICE_ID_EMULATOR);
                    for (String deviceId : m_TestDevices) {
                        adRequest.addTestDevice(deviceId);
                    }
                    m_AdBannerView.loadAd(adRequest.build());
                }
                m_AdBannerView.setVisibility(View.VISIBLE);
                m_IsAdBannerShowed = true;
            }
        });
    }

    public void HideAdBanner() {
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                if (!IsAdBannerShowed()) {
                    return;
                }

                m_AdBannerView.setVisibility(View.GONE);
                m_IsAdBannerShowed = false;
            }
        });
    }

    public void InitializeAdBanner() {
        final QtAdMobActivity self = this;
        runOnUiThread(new Runnable() {
            public void run() {
                if (m_AdBannerView != null) {
                    return;
                }

                m_StatusBarHeight = GetStatusBarHeight();

                m_AdBannerView = new AdView(self);
                m_AdBannerView.setVisibility(View.GONE);

                View view = getWindow().getDecorView().getRootView();
                if (view instanceof ViewGroup) {
                    m_ViewGroup = (ViewGroup) view;

                    FrameLayout.LayoutParams layoutParams = new FrameLayout.LayoutParams(FrameLayout.LayoutParams.WRAP_CONTENT,
                            FrameLayout.LayoutParams.WRAP_CONTENT,
                            Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL);

                    m_AdBannerView.setLayoutParams(layoutParams);

                    m_ViewGroup.addView(m_AdBannerView);

                    m_AdBannerView.setAdListener(new AdListener() {
                        public void onAdLoaded() {
                            m_IsAdBannerLoaded = true;
                        }
                    });
                }
            }
        });
    }

    public void ShutdownAdBanner() {
        runOnUiThread(new Runnable() {
            public void run() {
                if (m_AdBannerView == null) {
                    return;
                }

                m_IsAdBannerShowed = false;
                m_ViewGroup.removeView(m_AdBannerView);
                m_AdBannerView = null;
            }
        });
    }

    public void LoadAdInterstitialWithUnitId(final String adId) {
        Log.d(TAG, "LoadAdInterstitialWithUnitId:" + adId);
        final QtAdMobActivity self = this;
        runOnUiThread(new Runnable() {
            public void run() {
                Log.d(TAG, "LoadAdInterstitialWithUnitId runnable");

                m_IsAdInterstitialLoaded = false;
                m_IsAdInterstitiaNeedToShow = false;

                m_AdInterstitial = new InterstitialAd(self);
                m_AdInterstitial.setAdUnitId(adId);

                m_AdInterstitial.setAdListener(new AdListener() {
                    public void onAdLoaded() {
                        m_IsAdInterstitialLoaded = true;
                        ShowAdInterstitial();
                        Log.d(TAG, "LoadAdInterstitialWithUnitId onAdLoaded");
                    }
                });

                AdRequest.Builder adRequest = new AdRequest.Builder();
                adRequest.addTestDevice(AdRequest.DEVICE_ID_EMULATOR);
                for (String deviceId : m_TestDevices) {
                    adRequest.addTestDevice(deviceId);
                }
                m_AdInterstitial.loadAd(adRequest.build());
                m_AdInterstitial.show();

            }
        });
    }

    public boolean IsAdInterstitialLoaded() {
        return m_IsAdInterstitialLoaded;
    }

    public void ShowAdInterstitial() {
        runOnUiThread(new Runnable() {
            public void run() {
                if (m_IsAdInterstitialLoaded) {
                    m_AdInterstitial.show();
                    m_IsAdInterstitialLoaded = false; // Ad might be presented only once, need reload
                } else {
                    m_IsAdInterstitiaNeedToShow = true;
                }
            }
        });
    }

    public void createWebView(final String url) {

        RelativeLayout popwindow = new RelativeLayout(this);
        FrameLayout.LayoutParams rl = new FrameLayout.LayoutParams(FrameLayout.LayoutParams.WRAP_CONTENT, 50);
        popwindow.setLayoutParams(rl);

        w = new WebView(this);
        w.setScrollContainer(false);

        RelativeLayout.LayoutParams params = new RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT);
        params.addRule(RelativeLayout.ALIGN_PARENT_START);
        w.setLayoutParams(params);

        final WebSettings myWebViewSettings = w.getSettings();

        myWebViewSettings.setJavaScriptEnabled(true);
        myWebViewSettings.setDomStorageEnabled(true);
        myWebViewSettings.setAllowFileAccessFromFileURLs(true);
        myWebViewSettings.setAllowUniversalAccessFromFileURLs(true);

        String userAgent = System.getProperty("http.agent");

        myWebViewSettings.setUserAgentString(userAgent + ";androidWebView=1");

        w.post(new Runnable() {
            @Override
            public void run() {

                w.loadUrl(url);

            }
        });

        w.setWebViewClient(new WebViewClient());

        setContentView(w);
    }

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if (event.getAction() == KeyEvent.ACTION_DOWN) {
            switch (keyCode) {
                case KeyEvent.KEYCODE_BACK:
                    if (w.canGoBack()) {
                        w.goBack();
                    } else {
                        finish();
                    }
                    return true;
            }

        }
        return super.onKeyDown(keyCode, event);
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        //Fabric.with(this, new Crashlytics(), new CrashlyticsNdk());
        System.out.println("savedInstanceState");

        // Pushbots.sharedInstance().init(getApplication(),"123","790231305536","016c4d37d49356115ffd679b72c8265d","DEBUG");

        //ontext.addContentView(b,new ViewGroup.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT));
        //        throw new RuntimeException("This is a crash");
    }

    @Override
    public void onPause() {
        super.onPause();
        if (m_AdBannerView != null) {
            m_AdBannerView.pause();
        }
    }

    @Override
    public void onResume() {
        super.onResume();
        if (m_AdBannerView != null) {
            m_AdBannerView.resume();
        }
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        if (m_AdBannerView != null) {
            m_AdBannerView.destroy();
        }
    }
}
