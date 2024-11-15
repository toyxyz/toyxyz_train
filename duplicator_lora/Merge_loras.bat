@echo off
setlocal ENABLEDELAYEDEXPANSION

::This batch file merges multiple Lora trained with batch_train.

::To use this batch file, you need to install sd-scripts developed by kohya-ss.  https://github.com/kohya-ss/sd-scripts

:: Activate the virtual environment. If your venv has a different name and path, modify this part. 
call .\venv\Scripts\activate.bat

:: Set output Lora path. The path to the merged LORA file.
set merge_dir="C:\train\merged_lora.safetensors"

:: Set Lora path. Paths of multiple lora trained with batch_train. 
set dir_path="C:\train\batch"


::=======================================================================================================::

:: Prepare Lora path list
set file_names=

:: Initialize variables
set ratio_list=""
set /a count=0

:: First pass: Count total files
for %%f in ("%dir_path%\*") do (
    set /a count+=1
)

:: Calculate individual ratio (1 / total files)
set /a total_ratio_base=100000
set /a ratio_calculated=%total_ratio_base% / %count%
set ratio=0.%ratio_calculated%

:: Second pass: Prepare file names and ratio list
for %%f in ("%dir_path%\*") do (
    set "file_names=!file_names! %%f"
    set "ratio_list=!ratio_list!!ratio! "
)

echo Lora in dir: !file_names!
echo Count : !count!
echo Ratio list : !ratio_list!

:: Run the merge script. If you want to change the LORA merge parameters, modify here. https://github.com/kohya-ss/sd-scripts/blob/main/docs/train_network_README-ja.md
"networks/svd_merge_lora.py" --save_precision "fp16" --precision "float" --save_to %merge_dir% --models !file_names! --ratios !ratio_list! --new_rank 128 --device "cuda"

pause
