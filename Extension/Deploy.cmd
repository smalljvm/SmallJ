rem Copies this extension to VSCode extensions folder, where it is automatically used.
set dest="%UserProfile%\.vscode\extensions\mysmalltalk"
md %dest%
xcopy /y /s /h . %dest%
pause
