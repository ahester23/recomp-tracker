const CACHE = 'load-log-v1';
const SHELL = ['./', './index.html', './manifest.json', './icon-180.png', './icon-192.png', './icon-512.png'];

self.addEventListener('install', function(event){
  self.skipWaiting();
  event.waitUntil(caches.open(CACHE).then(function(cache){ return cache.addAll(SHELL); }));
});

self.addEventListener('activate', function(event){
  event.waitUntil(
    caches.keys().then(function(keys){
      return Promise.all(keys.filter(function(k){ return k !== CACHE; }).map(function(k){ return caches.delete(k); }));
    }).then(function(){ return self.clients.claim(); })
  );
});

self.addEventListener('fetch', function(event){
  const req = event.request;
  if(req.method !== 'GET' || new URL(req.url).origin !== self.location.origin){
    return;
  }
  event.respondWith(
    caches.match(req).then(function(cached){
      const network = fetch(req).then(function(res){
        if(res && res.ok) caches.open(CACHE).then(function(cache){ cache.put(req, res.clone()); });
        return res;
      }).catch(function(){ return cached; });
      return cached || network;
    })
  );
});
