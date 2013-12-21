###############################################################
# Mongoose <stu7440@westga.edu>
###############################################################
# + Cleaner clean
# + Add new include tree
# + Add new flags
# + Install/Uninstall
# + Debian and Redhat packaging
# + Lots of misc new features
###############################################################
BUILD_SELECT=debug

NAME=OpenRaider
NAME_DEB=openraider
MAJOR_VERSION=0
MINOR_VERSION=1
MICRO_VERSION=1
BUILD_ID=20131214
PRE=
VERSION=$(MAJOR_VERSION).$(MINOR_VERSION).$(MICRO_VERSION)$(PRE)
VERSION_DEB=$(MAJOR_VERSION).$(MINOR_VERSION).$(MICRO_VERSION).$(BUILD_ID)
BUILD_HOST=$(shell uname -s -n -r -m)
ARCH=$(shell uname -m)
#ARCH=i386
UNAME=$(shell uname -s)

###############################################################

# -DUSING_OPENAL		Add OpenAL sound support
# -DMULTITEXTURE		Add OpenGL multitexturing
# -DUNICODE_SUPPORT		Add unicode/internation keyboard support
# -DUSING_EMITTER_IN_GAME	Run particle test in game
BASE_DEFS=$(shell sdl-config --cflags) -Isrc -I/opt/local/include -DSDL_INTERFACE \
	-DUSING_OPENGL -DZLIB_SUPPORT -DUSING_EMITTER \
	-DUSING_OPENAL -DUSING_MTK_TGA -DUSING_PTHREADS \
	-DUSING_HEL -DHAVE_SDL_TTF -DHAVE_OPENGL

BASE_LIBS=$(shell sdl-config --libs) -lz -lstdc++ \
	-lpthread -lSDL_ttf

# -DDEBUG_GL
DEBUG_DEFS=-DDEBUG -DEXPERIMENTAL
DEBUG_OBJ=

###############################################################
# OpenAL, Sound support
BASE_DEFS += -DHAVE_OPENAL

ifeq ($(UNAME),Darwin)
BASE_LIBS += -lalut
BASE_LIBS += -framework OpenAL
BASE_LIBS += -framework OpenGL
BASE_LIBS += -framework GLUT
else
BASE_LIBS += -lopenal
endif

# libferit, File transfer via HTTP/FTP/etc support
LIBFERIT_LIB=/usr/local/lib/libferit.so
LIBFERIT=$(shell if test -e $(LIBFERIT_LIB) > /dev/null; then echo yes; fi)

ifeq ($(LIBFERIT), yes)
	BASE_DEFS += -DHAVE_LIBFERIT
	BASE_LIBS += -lferit
endif

###############################################################

TREE_DIR=OpenRaider
BUILD_DEBUG_DIR=bin/debug
BUILD_RELEASE_DIR=bin/release
BUILD_PROF_DIR=bin/prof
BUILD_TEST_DIR=bin/test
BUILD_MEM_DIR=bin/mem
BUILD_INSTALL_DIR=bin/$(BUILD_SELECT)
DEB_DIR=/tmp/$(NAME).deb

# Edited for Debian GNU/Linux.
DESTDIR =
INSTALL_BIN=$(DESTDIR)/usr/games
INSTALL_LIB=$(DESTDIR)/usr/lib
INSTALL_DOC=$(DESTDIR)/usr/share/doc/$(NAME)
INSTALL_SHARE=$(DESTDIR)/usr/share/$(NAME)
INSTALL_INCLUDE=$(DESTDIR)/usr/include

###############################################################
CC=gcc

BASE_CFLAGS=-Wall $(BASE_DEFS) \
	-DVERSION=\"\\\"$(NAME)-$(VERSION)-$(BUILD_ID)\\\"\" \
	-DBUILD_HOST=\"\\\"$(BUILD_HOST)\\\"\"

LD_FLAGS=-L/usr/X11/lib -lXmu -lXt -lSM -lICE -lXext -lX11 -lXi \
	 -lm $(BASE_LIBS)

ifneq ($(UNAME),Darwin)
LD_FLAGS+=-lGL -lGLU
endif

RELEASE_CFLAGS=$(BASE_CFLAGS) -ffast-math -funroll-loops \
	-fomit-frame-pointer -fexpensive-optimizations -O2

DEBUG_CFLAGS=$(BASE_CFLAGS) -g -O0 $(DEBUG_DEFS)

################################################################

DO_CC=$(CC) $(CFLAGS) -o $@ -c $<
DO_SHLIB_CC=$(CC) $(CFLAGS) $(SHLIBCFLAGS) -o $@ -c $<

TARGETS=$(BUILDDIR)/$(NAME)

################################################################
auto: $(BUILD_SELECT)

targets: $(TARGETS)

bundle: release
	mkdir -p bin/OpenRaider.app/Contents/MacOS
	mkdir -p bin/OpenRaider.app/Contents/Resources/defaults
	mkdir -p bin/OpenRaider.app/Contents/Frameworks
	cp mac_dist/Info.plist bin/OpenRaider.app/Contents/Info.plist
	cp mac_dist/openraider.icns bin/OpenRaider.app/Contents/Resources/openraider.icns
	cp mac_dist/OpenRaider bin/OpenRaider.app/Contents/MacOS/OpenRaider
	cp bin/release/OpenRaider bin/OpenRaider.app/Contents/MacOS/OpenRaider-bin
	cp data/* bin/OpenRaider.app/Contents/Resources/defaults/
	cp /opt/local/lib/libalut.0.1.0.dylib bin/OpenRaider.app/Contents/Frameworks/libalut.0.1.0.dylib
	cp /opt/local/lib/libSDL_ttf-2.0.0.dylib bin/OpenRaider.app/Contents/Frameworks/libSDL_ttf-2.0.0.dylib
	cp /opt/local/lib/libz.1.dylib bin/OpenRaider.app/Contents/Frameworks/libz.1.dylib
	cp /opt/local/lib/libSDL-1.2.0.dylib bin/OpenRaider.app/Contents/Frameworks/libSDL-1.2.0.dylib
	cp /opt/local/lib/libbz2.1.0.dylib bin/OpenRaider.app/Contents/Frameworks/libbz2.1.0.dylib
	cp /opt/local/lib/libfreetype.6.dylib bin/OpenRaider.app/Contents/Frameworks/libfreetype.6.dylib
	cp /opt/local/lib/libpng15.15.dylib bin/OpenRaider.app/Contents/Frameworks/libpng15.15.dylib
	# OpenRaider-bin
	install_name_tool -change /opt/local/lib/libalut.0.1.0.dylib @executable_path/../Frameworks/libalut.0.1.0.dylib bin/OpenRaider.app/Contents/MacOS/OpenRaider-bin
	install_name_tool -change /opt/local/lib/libSDL_ttf-2.0.0.dylib @executable_path/../Frameworks/libSDL_ttf-2.0.0.dylib bin/OpenRaider.app/Contents/MacOS/OpenRaider-bin
	install_name_tool -change /opt/local/lib/libz.1.dylib @executable_path/../Frameworks/libz.1.dylib bin/OpenRaider.app/Contents/MacOS/OpenRaider-bin
	install_name_tool -change /opt/local/lib/libSDL-1.2.0.dylib @executable_path/../Frameworks/libSDL-1.2.0.dylib bin/OpenRaider.app/Contents/MacOS/OpenRaider-bin
	install_name_tool -change /opt/X11/lib/libXmu.6.dylib /usr/X11/lib/libXmu.6.dylib bin/OpenRaider.app/Contents/MacOS/OpenRaider-bin
	install_name_tool -change /opt/X11/lib/libXt.6.dylib /usr/X11/lib/libXt.6.dylib bin/OpenRaider.app/Contents/MacOS/OpenRaider-bin
	install_name_tool -change /opt/X11/lib/libSM.6.dylib /usr/X11/lib/libSM.6.dylib bin/OpenRaider.app/Contents/MacOS/OpenRaider-bin
	install_name_tool -change /opt/X11/lib/libICE.6.dylib /usr/X11/lib/libICE.6.dylib bin/OpenRaider.app/Contents/MacOS/OpenRaider-bin
	install_name_tool -change /opt/X11/lib/libXext.6.dylib /usr/X11/lib/libXext.6.dylib bin/OpenRaider.app/Contents/MacOS/OpenRaider-bin
	install_name_tool -change /opt/X11/lib/libX11.6.dylib /usr/X11/lib/libX11.6.dylib bin/OpenRaider.app/Contents/MacOS/OpenRaider-bin
	install_name_tool -change /opt/X11/lib/libXi.6.dylib /usr/X11/lib/libXi.6.dylib bin/OpenRaider.app/Contents/MacOS/OpenRaider-bin
	# libSDL-1.2.0.dylib
	install_name_tool -change /opt/local/lib/libX11.6.dylib /usr/X11/lib/libX11.6.dylib bin/OpenRaider.app/Contents/Frameworks/libSDL-1.2.0.dylib
	install_name_tool -change /opt/local/lib/libXext.6.dylib /usr/X11/lib/libXext.6.dylib bin/OpenRaider.app/Contents/Frameworks/libSDL-1.2.0.dylib
	install_name_tool -change /opt/local/lib/libXrandr.2.dylib /usr/X11/lib/libXrandr.2.dylib bin/OpenRaider.app/Contents/Frameworks/libSDL-1.2.0.dylib
	install_name_tool -change /opt/local/lib/libXrender.1.dylib /usr/X11/lib/libXrender.1.dylib bin/OpenRaider.app/Contents/Frameworks/libSDL-1.2.0.dylib
	# libSDL_ttf-2.0.0.dylib
	install_name_tool -change /opt/local/lib/libSDL-1.2.0.dylib @executable_path/../Frameworks/libSDL-1.2.0.dylib bin/OpenRaider.app/Contents/Frameworks/libSDL_ttf-2.0.0.dylib
	install_name_tool -change /opt/local/lib/libfreetype.6.dylib @executable_path/../Frameworks/libfreetype.6.dylib bin/OpenRaider.app/Contents/Frameworks/libSDL_ttf-2.0.0.dylib
	install_name_tool -change /opt/local/lib/libz.1.dylib @executable_path/../Frameworks/libz.1.dylib bin/OpenRaider.app/Contents/Frameworks/libSDL_ttf-2.0.0.dylib
	install_name_tool -change /opt/local/lib/libbz2.1.0.dylib @executable_path/../Frameworks/libbz2.1.0.dylib bin/OpenRaider.app/Contents/Frameworks/libSDL_ttf-2.0.0.dylib
	# libfreetype.6.dylib
	install_name_tool -change /opt/local/lib/libz.1.dylib @executable_path/../Frameworks/libz.1.dylib bin/OpenRaider.app/Contents/Frameworks/libfreetype.6.dylib
	install_name_tool -change /opt/local/lib/libbz2.1.0.dylib @executable_path/../Frameworks/libbz2.1.0.dylib bin/OpenRaider.app/Contents/Frameworks/libfreetype.6.dylib
	install_name_tool -change /opt/local/lib/libpng15.15.dylib @executable_path/../Frameworks/libpng15.15.dylib bin/OpenRaider.app/Contents/Frameworks/libfreetype.6.dylib
	# libpng15.15.dylib
	install_name_tool -change /opt/local/lib/libz.1.dylib @executable_path/../Frameworks/libz.1.dylib bin/OpenRaider.app/Contents/Frameworks/libpng15.15.dylib

bundle-image: bundle
	hdiutil create -size 32m -fs HFS+ -volname "OpenRaider" bin/tmp.dmg
	hdiutil attach bin/tmp.dmg
	cp -r bin/OpenRaider.app /Volumes/OpenRaider/OpenRaider.app
	osascript -e 'tell application "Finder" to make alias file to POSIX file "/Applications" at POSIX file "/Volumes/OpenRaider/"'
	hdiutil detach /Volumes/OpenRaider
	hdiutil convert bin/tmp.dmg -format UDZO -o bin/OpenRaider.dmg
	rm -rf bin/tmp.dmg

all: debug release prof

debug:
	@-mkdir -p $(BUILD_DEBUG_DIR)
	$(MAKE) targets BUILDDIR=$(BUILD_DEBUG_DIR) \
	CFLAGS="$(DEBUG_CFLAGS)" \
	LD_FLAGS="$(LD_FLAGS)"

prof:
	@-mkdir -p $(BUILD_PROF_DIR)
	$(MAKE) targets BUILDDIR=$(BUILD_PROF_DIR) \
	CFLAGS="$(DEBUG_CFLAGS) -pg" \
	LD_FLAGS="$(LD_FLAGS) -pg"

release:
	@-mkdir -p $(BUILD_RELEASE_DIR)
	$(MAKE) targets BUILDDIR=$(BUILD_RELEASE_DIR) \
	CFLAGS="$(RELEASE_CFLAGS)" \
	LD_FLAGS="$(LD_FLAGS)"

#####################################

ded:
	@-mkdir -p $(BUILD_DEBUG_DIR)/ded
	$(MAKE) targets BUILDDIR=$(BUILD_DEBUG_DIR)/ded \
	CFLAGS="$(DEBUG_CFLAGS) -DDEDICATED_SERVER" \
	LD_FLAGS="$(LD_FLAGS)"

md3:
	@-mkdir -p $(BUILD_DEBUG_DIR)
	$(MAKE) targets BUILDDIR=$(BUILD_DEBUG_DIR) \
	DEBUG_OBJ="$(BUILD_DEBUG_DIR)/endian.o $(BUILD_DEBUG_DIR)/Md3.o $(BUILD_DEBUG_DIR)/Md3AnimModel.o" \
	CFLAGS="$(DEBUG_CFLAGS) -DUSING_MD3" \
	LD_FLAGS="$(LD_FLAGS)"

# -DDEBUG_MEMEORY_VERBOSE
# -DDEBUG_MEMEORY
memory:
	@-mkdir -p $(BUILD_MEM_DIR)
	$(MAKE) targets BUILDDIR=$(BUILD_MEM_DIR) \
	DEBUG_OBJ="$(BUILD_MEM_DIR)/memeory_test.o" \
	CFLAGS="$(DEBUG_CFLAGS) -DDEBUG_MEMEORY" \
	LD_FLAGS="$(LD_FLAGS)"

depend:
	@-echo "Making deps..."
	@-echo "# Autogenerated dependency file" > depend
	@-find ./src -name "*.cpp" -exec ./deps.sh $(BASE_DEFS) {} \; >> depend
	@-echo "[DONE]"

################################################################

# Later hel will become a seperate library once it matures
HEL_OBJ = \
	$(BUILDDIR)/Mass.o \
	$(BUILDDIR)/Simulation.o \
	$(BUILDDIR)/Vector3d.o \
	$(BUILDDIR)/Matrix.o \
	$(BUILDDIR)/ViewVolume.o \
	$(BUILDDIR)/CollisionObject.o \
	$(BUILDDIR)/BoundingVolume.o \
	$(BUILDDIR)/Quaternion.o \
	$(BUILDDIR)/math.o \
	$(BUILDDIR)/Entity.o
	#$(BUILDDIR)/Spring.o

OBJS = \
	$(DEBUG_OBJ) \
	$(HEL_OBJ) \
	$(BUILDDIR)/mtk_tga.o \
	$(BUILDDIR)/System.o \
	$(BUILDDIR)/SDLSystem.o \
	$(BUILDDIR)/OpenRaider.o \
	$(BUILDDIR)/World.o \
	$(BUILDDIR)/TombRaider.o \
	$(BUILDDIR)/GLString.o \
	$(BUILDDIR)/Camera.o \
	$(BUILDDIR)/OpenGLMesh.o \
	$(BUILDDIR)/Render.o \
	$(BUILDDIR)/Sound.o \
	$(BUILDDIR)/Network.o \
	$(BUILDDIR)/Texture.o \
	$(BUILDDIR)/Emitter.o \
	$(BUILDDIR)/Particle.o \
	$(BUILDDIR)/SkeletalModel.o \
	$(BUILDDIR)/Light.o


$(BUILDDIR)/$(NAME) : $(OBJS)
	$(CC) $(CFLAGS) $(LD_FLAGS) -o $@ $(OBJS)
ifeq ($(UNAME),Darwin)
	install_name_tool -change libalut.0.1.0.dylib /opt/local/lib/libalut.0.1.0.dylib $@
endif

#################################################################

clean: clean-emacs clean-build clean-test clean-obj clean-dep
	@-rm -rf bin/OpenRaider.app
	@-rm -rf bin/OpenRaider.dmg

clean-dep:
	@-echo "Cleaning dependencies                        "
	@-rm -f depend
	@-echo "[DONE]"

clean-test:
	@-echo "Cleaning test builds                         "
	@-rm -f $(BUILD_TEST_DIR)/*.o
	@-rm -f $(BUILD_TEST_DIR)/*.test
	@-rm -rf $(BUILD_TEST_DIR)/*.build
	@-echo "[DONE]"

clean-obj:
	@-echo "Cleaning objects                             "
	@-rm -f $(BUILD_PROF_DIR)/*.o
	@-rm -f $(BUILD_DEBUG_DIR)/*.o
	@-rm -f $(BUILD_RELEASE_DIR)/*.o
	@-rm -f $(BUILD_TEST_DIR)/*.o
	@-rm -f $(BUILD_MEM_DIR)/*.o
	@-echo "[DONE]"

clean-emacs:
	@-echo "Cleaning emacs files                         "
	@-rm -f `find . -name "*~" -print`
	@-echo "[DONE]"

clean-build:
	@-echo "Cleaning builds                              "
	@-rm -f $(BUILD_PROF_DIR)/$(NAME)
	@-rm -f $(BUILD_DEBUG_DIR)/$(NAME)
	@-rm -f $(BUILD_RELEASE_DIR)/$(NAME)
	@-rm -f $(BUILD_MEM_DIR)/$(NAME)
	@-echo "[DONE]"

clean-deb:
	@-echo "Cleaning DEBs                                "
	@-rm -rf $(DEB_DIR)
	@-echo "[DONE]"

#################################################################

-include depend

#################################################################

redhat:
	cd $(DEB_DIR) && \
		alien --to-rpm $(NAME_DEB)_$(VERSION_DEB)-1_$(ARCH).deb

debian:
	$(MAKE) tarball
	$(MAKE) clean-deb
	mkdir -p $(DEB_DIR)
	cp ../$(NAME_DEB)-$(VERSION_DEB).tar.gz $(DEB_DIR)
	cd $(DEB_DIR) && tar zxvf $(NAME_DEB)-$(VERSION_DEB).tar.gz && mv $(TREE_DIR) $(NAME_DEB)-$(VERSION_DEB) && cd $(NAME_DEB)-$(VERSION_DEB) && make deb-init && make deb

deb-init:
	dh_make -c gpl -s \
	-e mongoose@icculus.org -f ../$(NAME_DEB)-$(VERSION_DEB).tar.gz
	@-cp debian/control debian/control.old
	@-sed -e "s/<insert up to 60 chars description>/Open source Tomb Raider series clone/g" debian/control.old > debian/control
	@-rm -f debian/control.old
	@-cp debian/control debian/control.old
	@-sed -e "s/<insert long description, indented with spaces>/OpenRaider is an open source multiplayer and single player Tomb Raider clone for linux and Playstation 2. It uses the game data such as models, sound, levels,  and animation from the popular 3d series Tomb Raider by Core Design./g" debian/control.old > debian/control
	@-rm -f debian/control.old

deb:
	dpkg-buildpackage -rfakeroot

apt:
	cd $(DEB_DIR) && dpkg-scanpackages . /dev/null | gzip -9c > Packages.gz
	cd $(DEB_DIR) && dpkg-scansources . /dev/null | gzip -9c > Sources.gz

apt-upload:
	scp $(DEB_DIR)/Packages.gz \
		$(DEB_DIR)/Sources.gz \
		$(DEB_DIR)/$(NAME_DEB)*.diff.gz  \
		$(DEB_DIR)/$(NAME_DEB)*.deb \
		$(DEB_DIR)/$(NAME_DEB)*.dsc \
		$(DEB_DIR)/$(NAME_DEB)*.orig.tar.gz \
	orbital.sf.net:~/openraider/htdocs/debian/

install:
	mkdir -p $(INSTALL_SHARE)/data
	cp setup.sh $(INSTALL_SHARE)
	cp data/* $(INSTALL_SHARE)/data
	mkdir -p $(INSTALL_DOC)
	cp README ChangeLog BUGS TODO $(INSTALL_DOC)
	mkdir -p $(INSTALL_BIN)
	cp bin/$(BUILD_SELECT)/OpenRaider $(INSTALL_BIN)

bin-tarball:
	$(MAKE) clean-obj
	@-cd .. && tar zcvf $(NAME_DEB)-$(VERSION_DEB)-$(ARCH).tar.gz \
		$(TREE_DIR)/Makefile $(TREE_DIR)/data \
		$(TREE_DIR)/bin/$(BUILD_SELECT)/OpenRaider \
		$(TREE_DIR)/README $(TREE_DIR)/ChangeLog \
		$(TREE_DIR)/BUGS $(TREE_DIR)/TODO

tarball:
	@-echo "Making tarball                                  " 
	@-cd .. && tar zcvf $(NAME_DEB)-$(VERSION_DEB).tar.gz \
		$(TREE_DIR) --exclude old --exclude models \
		--exclude semantic.cache --exclude TAGS \
		--exclude bin --exclude CVS --exclude *~ 
	@-echo "[DONE]"

PSKModel.zip:
	@-echo "Making PSKModel pak                             " 
	@-zip ../pskmodel-$(BUILD_ID)-src.zip \
		Makefile deps.sh README.PSKModel \
		src/PSKModel.h src/PSKModel.cpp \
		src/UTPackage.h src/UTPackage.cpp \
		src/Texture.h src/Texture.cpp \
		src/mtk_tga.cpp src/mtk_tga.h
	@-echo "[DONE]"
	@-echo "Making test data pak                            " 
	@-zip -r ../pskmodel-$(BUILD_ID)-data.zip \
		data/models/test/ 
	@-echo "[DONE]"

backup:
	$(MAKE) tarball
	@-cd .. && cp $(NAME)-$(VERSION)-$(BUILD_ID).tar.gz ~/Backup


#################################################################
# Unit Test builds
#################################################################
TEST_FLAGS=-Wall -g -O0 -DDEBUG -lstdc++

TEST_MAP_TR5=~/projects/Data/models/tombraider/tr5/demo.trc
TEST_MAP_TR4=~/projects/Data/models/tombraider/tr4/angkor1.tr4
TEST_MAP_TR3=~/projects/Data/models/tombraider/tr3/scotland.tr2
TEST_MAP_TR2=~/projects/Data/models/tombraider/tr2/unwater.tr2
TEST_MAP_TR1=~/projects/Data/models/tombraider/tr1/level1.phd

TombRaider.reg_test:
	$(MAKE) TombRaider.test
	$(BUILD_TEST_DIR)/TombRaider.test load $(TEST_MAP_TR1) > /tmp/log.tr1
	$(BUILD_TEST_DIR)/TombRaider.test load $(TEST_MAP_TR2) > /tmp/log.tr2
	$(BUILD_TEST_DIR)/TombRaider.test load $(TEST_MAP_TR3) > /tmp/log.tr3
	$(BUILD_TEST_DIR)/TombRaider.test load $(TEST_MAP_TR4) > /tmp/log.tr4
	$(BUILD_TEST_DIR)/TombRaider.test load $(TEST_MAP_TR5) > /tmp/log.tr5


TombRaider.test:
	@-mkdir -p $(BUILD_TEST_DIR)
	$(MAKE) targets NAME=TombRaider.test BUILDDIR=$(BUILD_TEST_DIR) \
	OBJS="$(BUILD_TEST_DIR)/TombRaider.o $(BUILD_TEST_DIR)/mtk_tga.o $(BUILD_TEST_DIR)/memeory_test.o" \
	CFLAGS="$(BASE_CFLAGS) -g -D__TOMBRAIDER_TEST__ -D__TEST_TR5_DUMP_TGA -D__TEST_32BIT_TEXTILES -DDEBUG_MEMEORY" \
	LD_FLAGS="-lz"

#################################################################

MD3ANIMMODEL_CFLAGS=-DUSING_OPENGL -DUNIT_TEST_MD3ANIMMODEL_SDL \
	-DUSING_MTK_TGA -DUSING_HEL $(shell sdl-config --cflags) \
	-DHAVE_SDL_TTF
MD3ANIMMODEL_LDFLAGS=-lm -lstdc++ -lGL -lGLU $(shell sdl-config --libs) \
	-lSDL_ttf
MD3ANIMMODEL_OBJS=$(BUILD_TEST_DIR)/mtk_tga.o \
	$(BUILD_TEST_DIR)/Texture.o $(BUILD_TEST_DIR)/endian.o \
	$(BUILD_TEST_DIR)/Quaternion.o \
	$(BUILD_TEST_DIR)/Md3.o $(BUILD_TEST_DIR)/Md3AnimModel.o

Md3AnimModel.test:
	mkdir -p $(BUILD_TEST_DIR)
	$(MAKE) targets \
	NAME=Md3AnimModel.test \
	BUILDDIR=$(BUILD_TEST_DIR) \
	OBJS="$(MD3ANIMMODEL_OBJS)" \
	CFLAGS=" -Wall -O0 -g -Isrc $(MD3ANIMMODEL_CFLAGS)" \
	LD_FLAGS="$(MD3ANIMMODEL_LDFLAGS)"

#################################################################

GLString.test:
	mkdir -p $(BUILD_TEST_DIR)
	$(CC) -Wall -Isrc -D__TEST__ -DHAVE_MTK -DHAVE_SDL -DUSING_MTK_TGA \
	$(shell sdl-config --cflags) $(shell sdl-config --libs) \
	-lGL -lGLU -lm \
	src/Texture.cpp src/mtk_tga.cpp \
	src/GLString.cpp -o $(BUILD_TEST_DIR)/GLString.test

#################################################################
SIMULATION_CFLAGS=-Wall -O0 -g -Isrc $(shell sdl-config --cflags) \
		-DUSING_OPENGL -DUSING_HEL -DUSING_MTK_TGA \
		-DUNIT_TEST_SIMULATION
SIMULATION_OBJS=$(BUILD_TEST_DIR)/mtk_tga.o $(BUILD_TEST_DIR)/Texture.o \
		$(BUILD_TEST_DIR)/Mass.o \
		$(BUILD_TEST_DIR)/CollisionObject.o \
		$(BUILD_TEST_DIR)/Simulation.o \
		$(BUILD_TEST_DIR)/Vector3d.o \
		$(BUILD_TEST_DIR)/Matrix.o \
		$(BUILD_TEST_DIR)/ViewVolume.o \
		$(BUILD_TEST_DIR)/BoundingVolume.o \
		$(BUILD_TEST_DIR)/Quaternion.o \
		$(BUILD_TEST_DIR)/math.o

Simulation.test:
	mkdir -p $(BUILD_TEST_DIR)
	$(MAKE) targets NAME=Simulation.test BUILDDIR=$(BUILD_TEST_DIR) \
		OBJS="$(SIMULATION_OBJS)" \
		CFLAGS="$(SIMULATION_CFLAGS)" \
		LD_FLAGS="-lm -lstdc++ -lGL -lGLU $(shell sdl-config --libs)"

#################################################################
HEL_PARTICLE_CFLAGS=-Wall -O0 -g -Isrc $(shell sdl-config --cflags) \
		-DUSING_OPENGL -DUSING_HEL -DUSING_MTK_TGA \
		-DUNIT_TEST_SPRING -DHAVE_SDL_TTF -lSDL_ttf
HEL_PARTICLE_OBJS=$(BUILD_TEST_DIR)/mtk_tga.o $(BUILD_TEST_DIR)/Texture.o \
		$(BUILD_TEST_DIR)/Mass.o \
		$(BUILD_TEST_DIR)/Spring.o \
		$(BUILD_TEST_DIR)/CollisionObject.o \
		$(BUILD_TEST_DIR)/Simulation.o \
		$(BUILD_TEST_DIR)/Vector3d.o \
		$(BUILD_TEST_DIR)/Matrix.o \
		$(BUILD_TEST_DIR)/ViewVolume.o \
		$(BUILD_TEST_DIR)/BoundingVolume.o \
		$(BUILD_TEST_DIR)/Quaternion.o \
		$(BUILD_TEST_DIR)/math.o

Spring.test:
	mkdir -p $(BUILD_TEST_DIR)
	$(MAKE) targets NAME=Spring.test BUILDDIR=$(BUILD_TEST_DIR) \
		OBJS="$(HEL_PARTICLE_OBJS)" \
		CFLAGS="$(HEL_PARTICLE_CFLAGS)" \
		LD_FLAGS="-lm -lstdc++ -lGL -lGLU $(shell sdl-config --libs)"

#################################################################

Hel.test: Quaternion.test Matrix.test Math.test

Matrix.test:
	@-echo "Building Matrix unit test"
	mkdir -p $(BUILD_TEST_DIR)
	$(CC) -Wall -g -DMATRIX_UNIT_TEST -lm -lstdc++ -Isrc \
	src/hel/Matrix.cpp src/hel/Quaternion.cpp src/hel/Vector3d.cpp \
	-o $(BUILD_TEST_DIR)/Matrix.test
	@-echo "================================================="
	@-echo "Running Matrix unit test"
	$(BUILD_TEST_DIR)/Matrix.test

Quaternion.test:
	@-echo "Building Quaternion unit test"
	mkdir -p $(BUILD_TEST_DIR)
	$(CC) -Wall -g -DQUATERNION_UNIT_TEST -lm -lstdc++ -Isrc \
	src/hel/Quaternion.cpp -o $(BUILD_TEST_DIR)/Quaternion.test
	@-echo "================================================="
	@-echo "Running Quaternion unit test"
	$(BUILD_TEST_DIR)/Quaternion.test

Math.test:
	@-echo "Building Math unit test"
	mkdir -p $(BUILD_TEST_DIR)
	$(CC) -Wall -g -DMATH_UNIT_TEST -lm -lstdc++ -Isrc \
	src/hel/math.cpp -o $(BUILD_TEST_DIR)/Math.test
	@-echo "================================================="
	@-echo "Running hel unit test"
	$(BUILD_TEST_DIR)/Math.test

#################################################################

Memeory.test:
	mkdir -p $(BUILD_TEST_DIR)
	$(CC) -Wall -g -D__TEST__ -lstdc++ \
	-DDEBUG_MEMEORY -DDEBUG_MEMEORY_ERROR \
	src/memeory_test.cpp -o $(BUILD_TEST_DIR)/memeory_test.test

#################################################################

Network.test:
	mkdir -p $(BUILD_TEST_DIR)
	$(CC) $(TEST_FLAGS) -DUNIT_TEST_NETWORK \
	src/Network.cpp -o $(BUILD_TEST_DIR)/Network.test

#################################################################

Sound.test:
	mkdir -p $(BUILD_TEST_DIR)
	$(CC) $(TEST_FLAGS) -DUNIT_TEST_SOUND \
		-DUSING_OPENAL -lopenal \
		src/Sound.cpp -o $(BUILD_TEST_DIR)/Sound.test

#################################################################

PSKModel.test:
	mkdir -p $(BUILD_TEST_DIR)
	$(MAKE) targets NAME=PSKModel.test BUILDDIR=$(BUILD_TEST_DIR) \
	OBJS="$(BUILD_TEST_DIR)/PSKModel.o $(BUILD_TEST_DIR)/UTPackage.o $(BUILD_TEST_DIR)/mtk_tga.o $(BUILD_TEST_DIR)/Texture.o" \
	CFLAGS="-Wall -O0 -g -Isrc -DUNIT_TEST_PSKMODEL -DUSING_OPENGL $(shell sdl-config --cflags) -DUSING_MTK_TGA -DHAVE_SDL_TTF" \
	LD_FLAGS="-lm -lstdc++ -lGL -lGLU $(shell sdl-config --libs) -lSDL_ttf"

#################################################################

UTPackage.test:
	mkdir -p $(BUILD_TEST_DIR)
	$(MAKE) targets NAME=UTPackage.test BUILDDIR=$(BUILD_TEST_DIR) \
	OBJS="$(BUILD_TEST_DIR)/UTPackage.o $(BUILD_TEST_DIR)/mtk_tga.o" \
	CFLAGS="-Wall -O0 -g -Isrc -DUNIT_TEST_UTPACKAGE -DUSING_MTK_TGA" \
	LD_FLAGS="-lm -lstdc++"

#################################################################
