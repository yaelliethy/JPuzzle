'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "assets/assets/images/7.svg": "f4c9d41ca51147a697c6e558212d0e9c",
"assets/assets/images/Horizontal-Block.png": "7355f13f4176bf11d28762718e95828f",
"assets/assets/images/9.svg": "3ed274d2aa5205139164e70228e6e84d",
"assets/assets/images/backgrounds/Linth.svg": "e860bedc65d74ba61a6b61b346f0738d",
"assets/assets/images/backgrounds/Kander.svg": "dad30563d4c1acc365cdb43c502fd148",
"assets/assets/images/backgrounds/Waimakariri.svg": "ba19b816bc814b803800ad434d947bcf",
"assets/assets/images/backgrounds/Ngaruroro.svg": "8a341e3a7a027541b98c064a5f19255e",
"assets/assets/images/backgrounds/Vorderrhein.svg": "a208e256815d417efc82f2ff58935ae0",
"assets/assets/images/backgrounds/Wairau.svg": "e91cb35e21d9c34c27bb00670051f525",
"assets/assets/images/backgrounds/Rho%25E2%2595%25A0%25C3%25A9ne.svg": "44750f4bdd179ac4e6179c364f400c1f",
"assets/assets/images/backgrounds/Taieri.svg": "cf3c80a012915aa0edc3ceeaec6562ac",
"assets/assets/images/backgrounds/Whangaehu.svg": "acbef9da939072c1aa134b2a2be4ad34",
"assets/assets/images/backgrounds/Clarence.svg": "c61362d53549b67cf8a8657b292bcf88",
"assets/assets/images/backgrounds/Mataura.svg": "4afff881ad0867538212cf36816c625d",
"assets/assets/images/backgrounds/Aare.svg": "e84f13118b29a680abf4ba352e6998a7",
"assets/assets/images/backgrounds/Waiau.svg": "bd06fbd7bfc1e052546c2eb46b8a569b",
"assets/assets/images/backgrounds/Rangitikei.svg": "7b342156387fd47b58f567286be00020",
"assets/assets/images/backgrounds/Inn.svg": "64bd2963b32a2e14effc078f13a7beff",
"assets/assets/images/backgrounds/Oreti.svg": "8c3d5f71d6b98e1e54671cc5232bb6a8",
"assets/assets/images/backgrounds/Waihou.svg": "72f5049abf2caa0eb56cd168f7159fb0",
"assets/assets/images/backgrounds/Reuss.svg": "0f03a74141a2444034986a0c53d9f838",
"assets/assets/images/backgrounds/Mohaka.svg": "c27f4bb02eac4c0b2f0118c1fd653da1",
"assets/assets/images/backgrounds/Thur.svg": "a68cd0576f7c7f609178cb47c2503c98",
"assets/assets/images/backgrounds/Hinterrhein.svg": "bb02f73d04812ff688ac3c20d82af2f8",
"assets/assets/images/backgrounds/Doubs.svg": "99fb97b505e617ebd13f1fec40a09b3d",
"assets/assets/images/5.svg": "b29b174a72092fb26e87d1dddaf4485a",
"assets/assets/images/google.png": "1b943d724cb2d7c49f888f750ce3a479",
"assets/assets/images/3.svg": "0d45275d4c7bc2e006d90e37c5eea110",
"assets/assets/images/8.svg": "4ee2f9f295be23b3b001dda30f0aaeca",
"assets/assets/images/4.svg": "793fab8288016b4e9c5ea2098147aa32",
"assets/assets/images/rocket.png": "b8de18c84d29fe20c145863d828f653c",
"assets/assets/images/6.svg": "94ff8d79845ffdfec2ddb8e9b143ccdd",
"assets/assets/images/tiles/vertical.svg": "b7ac5d352553dc602167ee186a75d801",
"assets/assets/images/tiles/round.svg": "b605933e40081b4cfbc02e539b092023",
"assets/assets/images/tiles/placeholder.svg": "4c4570b30c6d69a709d5625167fdef12",
"assets/assets/images/tiles/target.svg": "1064d0d2784d7407f43cfb786caca9ef",
"assets/FontManifest.json": "5a32d4310a6f5d9a6b651e75ba0d7372",
"assets/packages/expandable_widgets/assets/background.png": "f1f2b9f95d2c2bb481acc14f4fad8196",
"assets/packages/font_awesome_flutter/lib/fonts/fa-brands-400.ttf": "b37ae0f14cbc958316fac4635383b6e8",
"assets/packages/font_awesome_flutter/lib/fonts/fa-regular-400.ttf": "5178af1d278432bec8fc830d50996d6f",
"assets/packages/font_awesome_flutter/lib/fonts/fa-solid-900.ttf": "aa1ec80f1b30a51d64c72f669c1326a7",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "6d342eb68f170c97609e9da345464e5e",
"assets/AssetManifest.json": "8aee36e534947082bbd57748beb71228",
"assets/NOTICES": "35781dcb3cd8af3535ce3d48327c8282",
"assets/fonts/MaterialIcons-Regular.otf": "4e6447691c9509f7acdbf8a931a85ca1",
"index.html": "b5ec2783dd4acab0200d831ef3ad27be",
"/": "b5ec2783dd4acab0200d831ef3ad27be",
"version.json": "6a17e276a9fc132af8bab398bdbc03d7",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"main.dart.js": "3aea445956a7c0947df6531239431218",
"splash/img/light-1x.png": "c812b652e940c3a0b292722b591e2b2b",
"splash/img/dark-4x.png": "16d34147e574ed4f98cfe10de3227ee9",
"splash/img/light-4x.png": "16d34147e574ed4f98cfe10de3227ee9",
"splash/img/dark-1x.png": "c812b652e940c3a0b292722b591e2b2b",
"splash/img/light-3x.png": "d886922f1a3a6d5f8d86a4b286f94323",
"splash/img/dark-2x.png": "a6707513da4aca7e2bf07a4a55434084",
"splash/img/dark-3x.png": "d886922f1a3a6d5f8d86a4b286f94323",
"splash/img/light-2x.png": "a6707513da4aca7e2bf07a4a55434084",
"splash/style.css": "40e51c6f656d1d56e973491069bb567b",
"manifest.json": "065e50c9965f8d85470de8959ef81b81",
"canvaskit/profiling/canvaskit.js": "ae2949af4efc61d28a4a80fffa1db900",
"canvaskit/profiling/canvaskit.wasm": "95e736ab31147d1b2c7b25f11d4c32cd",
"canvaskit/canvaskit.js": "c2b4e5f3d7a3d82aed024e7249a78487",
"canvaskit/canvaskit.wasm": "4b83d89d9fecbea8ca46f2f760c5a9ba"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "/",
"main.dart.js",
"index.html",
"assets/NOTICES",
"assets/AssetManifest.json",
"assets/FontManifest.json"];
// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});

// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});

// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache.
        return response || fetch(event.request).then((response) => {
          cache.put(event.request, response.clone());
          return response;
        });
      })
    })
  );
});

self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});

// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}

// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
