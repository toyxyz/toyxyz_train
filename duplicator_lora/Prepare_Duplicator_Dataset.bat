@echo off
setlocal enabledelayedexpansion

:: This batch file places the images, or images and caption TXT, into the folder structure required for LORA training. 

:: Configuration

:: If the image has a caption(.txt). set to true. Must be the same name as the image. 
set use_tag=false

:: Image dir A. The path where the original, unmodified images are located. 
set dir_path="G:\desktop\test2\c"

:: Target path A. The path where the copied images will be saved. 
set target_path="G:\desktop\test2\train_2\c"

:: Target name A. The name of the folder where the image files are stored. A number is automatically added after the name. Example: original -> original_0, original_1
set target_name="original"

:: Class name A. Repeat count_<identifier> <class>. You can also enter just repeat count and it will work. 
set class_name="1000"



:: Image dir B. he path where the edited images are located. The rest is the same as A. 
set dir_path_b="G:\desktop\test2\g"

:: Target path B
set target_path_b="G:\desktop\test2\train_2\g"

:: Target name B
set target_name_b="edited"

:: Class name B
set class_name_b="1000"


::==============================================================================================::


:: Copy images A
set /a count=0
set "file_names="

for %%f in ("%dir_path%\*") do (
    if /i not "%%~xf"==".txt" (
        set "file_names=!file_names! %%f,"
        mkdir "%target_path%\%target_name%_!count!"
        mkdir "%target_path%\%target_name%_!count!\img\"%class_name%"" 
        copy %%f "%target_path%\%target_name%_!count!\img\"%class_name%"" 
        
        if /i "!use_tag!"=="true" (
            set "txt_file=%%~dpnf.txt"
            if exist "!txt_file!" (
                copy "!txt_file!" "%target_path%\%target_name%_!count!\img\"%class_name%"" 
            ) else (
                echo WARNING: No corresponding .txt file for %%~nxf
            )
        )
        set /a count+=1
    )
)

:: Copy images B
set /a count_b=0
set "file_names_b="

for %%f in ("%dir_path_b%\*") do (
    if /i not "%%~xf"==".txt" (
        set "file_names_b=!file_names_b! %%f,"
        mkdir "%target_path_b%\%target_name_b%_!count_b!"
        mkdir "%target_path_b%\%target_name_b%_!count_b!\img\"%class_name_b%"" 
        copy %%f "%target_path_b%\%target_name_b%_!count_b!\img\"%class_name_b%"" 
        
        if /i "!use_tag!"=="true" (
            set "txt_file=%%~dpnf.txt"
            if exist "!txt_file!" (
                copy "!txt_file!" "%target_path_b%\%target_name_b%_!count_b!\img\"%class_name_b%"" 
            ) else (
                echo WARNING: No corresponding .txt file for %%~nxf
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
