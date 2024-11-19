@echo off
setlocal enabledelayedexpansion

:: This batch file places the images, or images and caption TXT, into the folder structure required for LORA training. 

:: Configuration

:: If the image has a caption(.txt). set to true. Must be the same name as the image. 
set use_tag=false

::If true, the image will be duplicated in sizes of 1.0x, 0.75x, 0.5x. 
::To use multi_size, you need to install imagemagick and register it in your PATH. https://imagemagick.org/script/download.php
set multi_size=false

:: Image dir A. The path where the original, unmodified images are located. 
set "dir_path=G:\desktop\test3\train_4\o"

:: Target path A. The path where the copied images will be saved. 
set "target_path=G:\desktop\test3\train_4\train\o"

:: Target name A. The name of the folder where the image files are stored. A number is automatically added after the name. Example: original -> original_0, original_1
set "target_name=original"

:: Class name A. Repeat count_<identifier> <class>. You can also enter just repeat count and it will work. 
set "class_name=1000"


:: Image dir B. The path where the edited images are located. The rest is the same as A. 
set "dir_path_b=G:\desktop\test3\train_4\e"

set "target_path_b=G:\desktop\test3\train_4\train\e"

set "target_name_b=edited"

set "class_name_b=1000"

::==============================================================================================::
:: Copy images A
set /a count=0
set "file_names="
for %%f in ("%dir_path%\*") do (
    if /i not "%%~xf"==".txt" (
        set "file_names=!file_names! %%f,"
        mkdir "%target_path%\%target_name%_!count!\img\%class_name%"
        
        if "%multi_size%"=="true" (
            :: Full size (1x)
            magick "%%f" "%target_path%\%target_name%_!count!\img\%class_name%\%%~nxf_1024%%~xf"
            
            :: 0.75x size
            magick "%%f" -resize 75%% "%target_path%\%target_name%_!count!\img\%class_name%\%%~nxf_768%%~xf"
            
            :: 0.5x size
            magick "%%f" -resize 50%% "%target_path%\%target_name%_!count!\img\%class_name%\%%~nxf_512%%~xf"
            
            if /i "!use_tag!"=="true" (
                set "txt_file=%%~dpnf.txt"
                if exist "!txt_file!" (
                    copy "!txt_file!" "%target_path%\%target_name%_!count!\img\%class_name%\%%~nxf_1024.txt"
                    copy "!txt_file!" "%target_path%\%target_name%_!count!\img\%class_name%\%%~nxf_768.txt"
                    copy "!txt_file!" "%target_path%\%target_name%_!count!\img\%class_name%\%%~nxf_512.txt"
                ) else (
                    echo WARNING: No corresponding .txt file for %%~nxf
                )
            )
        ) else (
            copy "%%f" "%target_path%\%target_name%_!count!\img\%class_name%"
            
            if /i "!use_tag!"=="true" (
                set "txt_file=%%~dpnf.txt"
                if exist "!txt_file!" (
                    copy "!txt_file!" "%target_path%\%target_name%_!count!\img\%class_name%"
                ) else (
                    echo WARNING: No corresponding .txt file for %%~nxf
                )
            )
        )
        
        set /a count+=1
    )
)
:: Copy images B (same logic as above)
set /a count_b=0
set "file_names_b="
for %%f in ("%dir_path_b%\*") do (
    if /i not "%%~xf"==".txt" (
        set "file_names_b=!file_names_b! %%f,"
        mkdir "%target_path_b%\%target_name_b%_!count_b!\img\%class_name_b%"
        
        if "%multi_size%"=="true" (
            :: Full size (1x)
            magick "%%f" "%target_path_b%\%target_name_b%_!count_b!\img\%class_name_b%\%%~nxf_1024%%~xf"
            
            :: 0.75x size
            magick "%%f" -resize 75%% "%target_path_b%\%target_name_b%_!count_b!\img\%class_name_b%\%%~nxf_768%%~xf"
            
            :: 0.5x size
            magick "%%f" -resize 50%% "%target_path_b%\%target_name_b%_!count_b!\img\%class_name_b%\%%~nxf_512%%~xf"
            
            if /i "!use_tag!"=="true" (
                set "txt_file=%%~dpnf.txt"
                if exist "!txt_file!" (
                    copy "!txt_file!" "%target_path_b%\%target_name_b%_!count_b!\img\%class_name_b%\%%~nxf_1024.txt"
                    copy "!txt_file!" "%target_path_b%\%target_name_b%_!count_b!\img\%class_name_b%\%%~nxf_768.txt"
                    copy "!txt_file!" "%target_path_b%\%target_name_b%_!count_b!\img\%class_name_b%\%%~nxf_512.txt"
                ) else (
                    echo WARNING: No corresponding .txt file for %%~nxf
                )
            )
        ) else (
            copy "%%f" "%target_path_b%\%target_name_b%_!count_b!\img\%class_name_b%"
            
            if /i "!use_tag!"=="true" (
                set "txt_file=%%~dpnf.txt"
                if exist "!txt_file!" (
                    copy "!txt_file!" "%target_path_b%\%target_name_b%_!count_b!\img\%class_name_b%"
                ) else (
                    echo WARNING: No corresponding .txt file for %%~nxf
                )
            )
        )
        
        set /a count_b+=1
    )
)
echo All file names in directory_a:%file_names%
echo Total files_a: %count%
echo All file names in directory_b:%file_names_b%
echo Total files_b: %count_b%
endlocal
pause
