@Echo Off&Setlocal Enabledelayedexpansion
For /f "tokens=*" %%i in ('dir /a-d /b /s "%~dp0*.*"^|findstr /r ".jpg\> .png\> .gif\> .bmp\>"') do (Set n=
	For /f "tokens=1-2 delims=:" %%j in ('mediainfo "%%i"^|findstr "Width Height" ') do (
		Set /a n+=1
		Set "WH=%%k"&Set WH=!WH: =!&Set WH=!WH:pixels=!
		If !n!==1 (Set Width=!WH!) else (Set Height=!WH!)
	)
	Echo %%~nxi !Width! !Height!

	Echo %%~nxi !Width!>>PicSize.txt
	Echo %%~nxi !Height!>>PicSize.txt
)
Pause 
Exit

