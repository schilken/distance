'use strict';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "index.html": "08dbcfdc04a6565d727d72140896a96f",
"main.dart.js": "02b83717b2915234fb7bf60345f50894",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"manifest.json": "d1639924c86bad4ee01ec59f708d7aba",
"assets/LICENSE": "512f4ee143db51b23dfa15a5eed83dc1",
"assets/AssetManifest.json": "21eb666ca70f60251ba9eb7ae564d0f6",
"assets/FontManifest.json": "580ff1a5d08679ded8fcf5c6848cece7",
"assets/assets/images/icons8-sad.png": "de5c09ecb12c2614aa7ca2f70109098e",
"assets/assets/images/icons8-neutral.png": "f5acac50c5c6cc9ef1bb34dec8d1feb6",
"assets/assets/images/icons8-neutral-yellow.png": "3bf30fb3d5bcef0d4ba79cb76e5d71c9"
};

self.addEventListener('activate', function (event) {
  event.waitUntil(
    caches.keys().then(function (cacheName) {
      return caches.delete(cacheName);
    }).then(function (_) {
      return caches.open(CACHE_NAME);
    }).then(function (cache) {
      return cache.addAll(Object.keys(RESOURCES));
    })
  );
});

self.addEventListener('fetch', function (event) {
  event.respondWith(
    caches.match(event.request)
      .then(function (response) {
        if (response) {
          return response;
        }
        return fetch(event.request);
      })
  );
});
