@ECHO OFF

@REM WINVER Definition
@REM #define _WIN32_WINNT_NT4                    0x0400 // Windows NT 4.0
@REM #define _WIN32_WINNT_WIN2K                  0x0500 // Windows 2000
@REM #define _WIN32_WINNT_WINXP                  0x0501 // Windows XP
@REM #define _WIN32_WINNT_WS03                   0x0502 // Windows Server 2003
@REM #define _WIN32_WINNT_WIN6                   0x0600 // Windows Vista
@REM #define _WIN32_WINNT_VISTA                  0x0600 // Windows Vista
@REM #define _WIN32_WINNT_WS08                   0x0600 // Windows Server 2008
@REM #define _WIN32_WINNT_LONGHORN               0x0600 // Windows Vista
@REM #define _WIN32_WINNT_WIN7                   0x0601 // Windows 7
@REM #define _WIN32_WINNT_WIN8                   0x0602 // Windows 8
@REM #define _WIN32_WINNT_WINBLUE                0x0603 // Windows 8.1
@REM #define _WIN32_WINNT_WINTHRESHOLD           0x0A00 // Windows 10
@REM #define _WIN32_WINNT_WIN10                  0x0A00 // Windows 10

@REM VIM Build Options
@REM TCL=c:\ActiveTcl8 TCL_VER=85 TCL_VER_LONG=8.5 DYNAMIC_TCL=yes ^
@REM RUBY=c:\Ruby RUBY_VER=19 RUBY_VER_LONG=1.9.1 DYNAMIC_RUBY=yes ^
@REM PERL=C:\activeperl5 PERL_VER=516 DYNAMIC_PERL=yes ^
@REM LUA=C:\lua5 LUA_VER= DYNAMIC_LUA=yes ^
@REM MZSCHEME=c:\PLT MZSCHEME_VER=205_000 MZSCHEME_DEBUG=no DYNAMIC_MZSCHEME=yes


RMDIR /S/Q ..\nsis\build

SET VIM_OPTIONS=Features=HUGE DEFINES="-DFEAT_PROPORTIONAL_FONTS" ^
                OLE=yes IME=yes MBYTE=yes IME=yes GIME=yes DYNAMIC_IME=yes CSCOPE=yes ^
                POSTSCRIPT=yes DEBUG=no MAP=no COLOR_EMOJI=no ^
                USERNAME=wangkexiong USERDOMAIN=NOKIA

PUSHD ..\vim\src

@REM Building win32 version
MKDIR ..\..\nsis\build\x86
MKDIR ..\..\nsis\build\GvimExt32
call vc9varsall

SET VIM32_OPTIONS=%VIM_OPTIONS% SUBSYSTEM_VER=5.01 ^
                  PYTHON=C:\Python27(x86) PYTHON_VER=27 DYNAMIC_PYTHON=yes

nmake -f Make_mvc.mak GUI=yes %VIM32_OPTIONS%
COPY gvim.exe ..\..\nsis\build\x86\gvim.exe
nmake -f Make_mvc.mak GUI=yes %VIM32_OPTIONS% clean

nmake -f Make_mvc.mak GUI=no %VIM32_OPTIONS%
copy vim.exe ..\..\nsis\build\x86\vim.exe
copy install.exe ..\..\nsis\build\x86\install.exe
copy uninstal.exe ..\..\nsis\build\x86\uninstal.exe
copy vimrun.exe ..\..\nsis\build\x86\vimrun.exe
copy tee\tee.exe ..\..\nsis\build\x86\tee.exe
copy xxd\xxd.exe ..\..\nsis\build\x86\xxd.exe
copy GvimExt\gvimext.dll ..\..\nsis\build\GvimExt32\gvimext.dll
nmake -f Make_mvc.mak GUI=no %VIM32_OPTIONS% clean

@REM Building AMD64 version
MKDIR ..\..\nsis\build\amd64
MKDIR ..\..\nsis\build\GvimExt64
call vc9varsall amd64

SET VIM64_OPTIONS=%VIM_OPTIONS% CPU=AMD64 SUBSYSTEM_VER=5.02 ^
                  PYTHON=C:\Python27 PYTHON_VER=27 DYNAMIC_PYTHON=yes

nmake -f Make_mvc.mak GUI=yes %VIM64_OPTIONS%
copy gvim.exe ..\..\nsis\build\amd64\gvim.exe
nmake -f Make_mvc.mak GUI=yes %VIM64_OPTIONS% clean

nmake -f Make_mvc.mak GUI=no %VIM64_OPTIONS%
copy vim.exe ..\..\nsis\build\amd64\vim.exe
copy install.exe ..\..\nsis\build\amd64\install.exe
copy uninstal.exe ..\..\nsis\build\amd64\uninstal.exe
copy vimrun.exe ..\..\nsis\build\amd64\vimrun.exe
copy tee\tee.exe ..\..\nsis\build\amd64\tee.exe
copy xxd\xxd.exe ..\..\nsis\build\amd64\xxd.exe
copy GvimExt\gvimext.dll ..\..\nsis\build\GvimExt64\gvimext.dll
nmake -f Make_mvc.mak GUI=no %VIM64_OPTIONS% clean

@REM i18n
PUSHD po
nmake -f Make_mvc.mak install-all GETTEXT_PATH=C:\pythonxy\gettext\bin\
POPD

@REM makensis
sed -e 's/[ build]*\*[-a-zA-Z0-9.]*\*//g' -e 's/vim:tw=78://' ..\runtime\doc\uganda.txt | uniq > ..\..\nsis\uganda.nsis.txt

@REM unzip icon res
tar xvf ..\nsis\icons.zip -C ..\..\nsis
copy ..\nsis\gvim_version.nsh ..\..\nsis\.

POPD

pause
