var openInAppBrowser = function() {
    var url = 'https://cordova.apache.org';
    var target = '_blank';
    var options = "location = yes"
    var ref = mvpn.InAppBrowser.open(url, target, options);

    ref.addEventListener('loadstart', loadstartCallback);
    ref.addEventListener('loadstop', loadstopCallback);
    ref.addEventListener('loaderror', loaderrorCallback);
    ref.addEventListener('exit', exitCallback);

    function loadstartCallback(event) {
      console.log('Loading started: '  + event.url)
    }

    function loadstopCallback(event) {
      console.log('Loading finished: ' + event.url)
    }

    function loaderrorCallback(error) {
      console.log('Loading error: ' + error.message)
    }

    function exitCallback() {
      console.log('Browser is closed...')
    }
};

const expectedJson = {
	"error": {
	 "errors": [
	  {
	   "domain": "global",
	   "reason": "required",
	   "message": "Required parameter: q",
	   "locationType": "parameter",
	   "location": "q"
	  }
	 ],
	 "code": 400,
	 "message": "Required parameter: q"
	}
};

exports.defineAutoTests = function() {
    describe('InAppBrowser Test', function() {
        it('syncTest', function() {
            cordova.InAppBrowser = mvpn.InAppBrowser;
            openInAppBrowser();
            expect(true).toBe(true);

        });

        it('asyncTest', function(done) {
          setTimeout(function() {
            cordova.InAppBrowser = mvpn.InAppBrowser;
            openInAppBrowser();
            done();
          }, 100);
        });
    });

    describe('Fetch Test', function() {
        it('Fetch Async Test', function(done) {
          setTimeout(function() {
            mvpnFetch('https://www.googleapis.com/customsearch/v1')
            .then(response => {
                console.log('received response from testweb');
                return response.json();
            })
            .catch(err => {
                console.log('error getting json from response: ' + err);
            })
            .then(json => {
                console.log('received json: ' + JSON.stringify(json));
                expect(JSON.stringify(json).includes("Required parameter: q")).toBe(true);
            })
            done();
          }, 100);
        });
    });
};

exports.defineManualTests = function(contentEl, createActionButton) {
    createActionButton('InAppBrowser Test', function() {
        cordova.InAppBrowser = mvpn.InAppBrowser;
        openInAppBrowser();
    });

    createActionButton('Fetch Test', function() {
        mvpnFetch('https://www.googleapis.com/customsearch/v1')
        .then(response => {
            console.log('received response from testweb');
            return response.json();
        })
        .catch(err => {
            console.log('error getting json from response: ' + err);
        })
        .then(json => {
            console.log('received json: ' + JSON.stringify(json));
        })
    });
};