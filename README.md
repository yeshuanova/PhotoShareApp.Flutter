# PhotoShareApp.Flutter

顯示 [PhotoShareApp.Functions](https://github.com/yeshuanova/PhotoShareApp.Functions) 中所建立的縮圖與經過 Google Vision API 建立的 Label。

## Steps (for Android)

1. 先建立 Firebase Project 與 Functions，建立方式可參考 [PhotoShareApp.Functions](https://github.com/yeshuanova/PhotoShareApp.Functions) 內容。

2. Clone 專案

```bash
git clone git@github.com:yeshuanova/PhotoShareApp.Flutter.git
```

3. 將 `android/app/build.gradle` 中的 `applicationId` 修改為自己的 App ID。

4. 從使用的 Firebase Project 中新增支援的 Android 裝置，並下載 `google-services.json` config file 放到 `android/app/` 資料夾中。

5. 執行 Flutter Android App，即可在主畫面中看到 Firebase Project 中之前上傳過的圖片縮圖與 Label 結果。
