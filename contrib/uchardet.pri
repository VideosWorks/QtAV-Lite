UCHARDET_SRC = $$PWD/uchardet/src
INCLUDEPATH *= $$UCHARDET_SRC
DEPENDPATH *= $$UCHARDET_SRC
HEADERS *= \
    $$UCHARDET_SRC/CharDistribution.h \
    $$UCHARDET_SRC/JpCntx.h \
    $$UCHARDET_SRC/nsBig5Prober.h \
    $$UCHARDET_SRC/nsCharSetProber.h \
    $$UCHARDET_SRC/nsCodingStateMachine.h \
    $$UCHARDET_SRC/nscore.h \
    $$UCHARDET_SRC/nsEscCharsetProber.h \
    $$UCHARDET_SRC/nsEUCJPProber.h \
    $$UCHARDET_SRC/nsEUCKRProber.h \
    $$UCHARDET_SRC/nsEUCTWProber.h \
    $$UCHARDET_SRC/nsGB2312Prober.h \
    $$UCHARDET_SRC/nsHebrewProber.h \
    $$UCHARDET_SRC/nsLatin1Prober.h \
    $$UCHARDET_SRC/nsMBCSGroupProber.h \
    $$UCHARDET_SRC/nsPkgInt.h \
    $$UCHARDET_SRC/nsSBCharSetProber.h \
    $$UCHARDET_SRC/nsSBCSGroupProber.h \
    $$UCHARDET_SRC/nsSJISProber.h \
    $$UCHARDET_SRC/nsUniversalDetector.h \
    $$UCHARDET_SRC/nsUTF8Prober.h \
    $$UCHARDET_SRC/prmem.h \
    $$UCHARDET_SRC/uchardet.h
SOURCES *= \
    $$UCHARDET_SRC/CharDistribution.cpp \
    $$UCHARDET_SRC/JpCntx.cpp \
    $$UCHARDET_SRC/nsBig5Prober.cpp \
    $$UCHARDET_SRC/nsCharSetProber.cpp \
    $$UCHARDET_SRC/nsEscCharsetProber.cpp \
    $$UCHARDET_SRC/nsEscSM.cpp \
    $$UCHARDET_SRC/nsEUCJPProber.cpp \
    $$UCHARDET_SRC/nsEUCKRProber.cpp \
    $$UCHARDET_SRC/nsEUCTWProber.cpp \
    $$UCHARDET_SRC/nsGB2312Prober.cpp \
    $$UCHARDET_SRC/nsHebrewProber.cpp \
    $$UCHARDET_SRC/nsLatin1Prober.cpp \
    $$UCHARDET_SRC/nsMBCSGroupProber.cpp \
    $$UCHARDET_SRC/nsMBCSSM.cpp \
    $$UCHARDET_SRC/nsSBCharSetProber.cpp \
    $$UCHARDET_SRC/nsSBCSGroupProber.cpp \
    $$UCHARDET_SRC/nsSJISProber.cpp \
    $$UCHARDET_SRC/nsUniversalDetector.cpp \
    $$UCHARDET_SRC/nsUTF8Prober.cpp \
    $$UCHARDET_SRC/uchardet.cpp \
    $$UCHARDET_SRC/LangModels/LangArabicModel.cpp \
    $$UCHARDET_SRC/LangModels/LangBulgarianModel.cpp \
    $$UCHARDET_SRC/LangModels/LangDanishModel.cpp \
    $$UCHARDET_SRC/LangModels/LangEsperantoModel.cpp \
    $$UCHARDET_SRC/LangModels/LangFrenchModel.cpp \
    $$UCHARDET_SRC/LangModels/LangGermanModel.cpp \
    $$UCHARDET_SRC/LangModels/LangGreekModel.cpp \
    $$UCHARDET_SRC/LangModels/LangHebrewModel.cpp \
    $$UCHARDET_SRC/LangModels/LangHungarianModel.cpp \
    $$UCHARDET_SRC/LangModels/LangRussianModel.cpp \
    $$UCHARDET_SRC/LangModels/LangSpanishModel.cpp \
    $$UCHARDET_SRC/LangModels/LangThaiModel.cpp \
    $$UCHARDET_SRC/LangModels/LangTurkishModel.cpp \
    $$UCHARDET_SRC/LangModels/LangVietnameseModel.cpp
