@echo off
setlocal

REM ===== 設定 =====
set PROTO_DIR=proto
set GO_OUT=server
set CS_OUT=unity\Assets\Scripts\Generated

REM ===== protoc の存在チェック =====
where protoc >nul 2>nul
if errorlevel 1 (
  echo [ERROR] protoc not found in PATH
  exit /b 1
)

REM ===== 出力先作成 =====
if not exist "%GO_OUT%" mkdir "%GO_OUT%"
if not exist "%CS_OUT%" mkdir "%CS_OUT%"

echo === Generating Go code ===
protoc ^
  -I %PROTO_DIR% ^
  --go_out=%GO_OUT% ^
  --go-grpc_out=%GO_OUT% ^
  %PROTO_DIR%\common\empty.proto ^
  %PROTO_DIR%\game\common\transform.proto ^
  %PROTO_DIR%\game\common\player.proto ^
  %PROTO_DIR%\game\realtime\movement.proto ^
  %PROTO_DIR%\game\lobby\lobby.proto

if errorlevel 1 (
  echo [ERROR] Go proto generation failed
  exit /b 1
)

echo === Generating C# code ===
protoc ^
  -I %PROTO_DIR% ^
  --csharp_out=%CS_OUT% ^
  %PROTO_DIR%\common\empty.proto ^
  %PROTO_DIR%\game\common\transform.proto ^
  %PROTO_DIR%\game\common\player.proto ^
  %PROTO_DIR%\game\realtime\movement.proto ^
  %PROTO_DIR%\game\lobby\lobby.proto

if errorlevel 1 (
  echo [ERROR] C# proto generation failed
  exit /b 1
)

echo === Proto generation complete ===
endlocal
pause
