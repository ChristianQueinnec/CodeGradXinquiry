# Time-stamp: "2018-12-07 09:12:44 queinnec"

work : lint tests
clean :
	-rm *~

# ############## Working rules:

lint :
	eslint codegradxinquiry.js

nsp+snyk :
	npm link nsp
	node_modules/.bin/nsp check
#	npm link snyk
#	-node_modules/.bin/snyk test codegradxinquiry

# ############## NPM package
# Caution: npm takes the whole directory that is . and not the sole
# content of CodeGradXinquiry.tgz 

publish : lint nsp+snyk bower.json clean
	git status .
	-git commit -m "NPM publication `date`" .
	git push
	-rm -f CodeGradXinquiry.tgz
	m CodeGradXinquiry.tgz install
	cd tmp/CodeGradXinquiry/ && npm version patch && npm publish
	cp -pf tmp/CodeGradXinquiry/package.json .
	rm -rf tmp
	npm install -g codegradxinquiry@`jq -r .version < package.json`
#	m propagate

CodeGradXinquiry.tgz :
	-rm -rf tmp
	mkdir -p tmp
	cd tmp/ && \
	  git clone https://github.com/ChristianQueinnec/CodeGradXinquiry.git
	rm -rf tmp/CodeGradXinquiry/.git
	cp -p package.json tmp/CodeGradXinquiry/ 
	tar czf CodeGradXinquiry.tgz -C tmp CodeGradXinquiry
	tar tzf CodeGradXinquiry.tgz

REMOTE	=	www.paracamplus.com
install :
	-rm CodeGradXinquiry.tgz
	m CodeGradXinquiry.tgz
	rsync -avu CodeGradXinquiry.tgz \
		${REMOTE}:/var/www/www.paracamplus.com/Resources/Javascript/

propagate :
	npm install -g codegradxinquiry@`jq -r .version < package.json`
	cd ../CodeGradXagent    ; m update
	cd ../CodeGradXvmauthor ; m update
	cd ../CodeGradXenroll   ; m update
	cd ../CodeGradXmarker   ; m update
	cd ../CodeGradXmarker   ; npm install -S yasmini
	cd ../../Servers/np/Paracamplus-*/;    m refresh.codegradx
	cd ../../Servers/w.js/Paracamplus-*/;  m refresh.codegradx
	cd ../../Servers/w.ncc/Paracamplus-*/; m refresh.codegradx
	cd ../../Servers/w.unx2/Paracamplus-*/; m refresh.codegradx
	cd ../../Servers/w.njfp/Paracamplus-*/; m refresh.codegradx
	grep '"codegradxinquiry":' ../CodeGradX*/package.json

# ############## bower

bower.json : package.json
	node npm2bower.js

bower.registration :
	node_modules/.bin/bower register codegradxinquiry https://github.com/ChristianQueinnec/CodeGradXinquiry.git

# ############## Various experiments (not all finished)

README.tex : README.md
	pandoc -o README.tex -f markdown README.md 
README.pdf : README.tex
	pandoc -o README.pdf -f markdown README.md 

doc : doc/index.html
doc/index.html : codegradxinquiry.js
	node_modules/.bin/jsdoc -c conf.json codegradxinquiry.js

docco :
	docco codegradxinquiry.js

browserify :
	browserify codegradxinquiry.js -o codegradxinquiry-bundle.js

uglifyjs :
	uglifyjs codegradx.js -c "evaluate=false" \
		-m --source-map codegradx.min.map -o codegradx.min.js

phantomjs :
	phantomjs test/run-jasmine.js test/jasmine.html

# end of Makefile


# end of Makefile
