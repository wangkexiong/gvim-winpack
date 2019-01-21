@ECHO OFF

IF NOT EXIST ..\vim\src\proto GOTO :EOF

PUSHD ..\vim\src\proto\

FOR /F "usebackq tokens=*" %%G IN (`FINDSTR /I /C:"uint8_t" term.pro`) DO (
  SET NEED_ADD_UINT8_DEF=TRUE
)

IF %NEED_ADD_UINT8_DEF%==TRUE (
  REN term.pro term.pro.old
  ECHO #include "stdint.h" > term.pro
  TYPE term.pro.old >> term.pro
  DEL /Q term.pro.old
  COPY ..\..\..\patch\stdint.h .
)

POPD

