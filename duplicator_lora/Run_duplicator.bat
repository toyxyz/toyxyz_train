@echo off
setlocal ENABLEDELAYEDEXPANSION

:: This batch file trains lora using image A, merges it into the base model, and generates lora by training image B on the merged model. 
:: To use this batch file, you need to install sd-scripts developed by kohya-ss.  https://github.com/kohya-ss/sd-scripts

:: Activate the virtual environment. If your venv has a different name and path, modify this part. 
call .\venv\Scripts\activate.bat

::=========================================================================================::


:: Loop settings

:: Change to true if you want to batch train multiple images. Make sure to properly prepare your dataset. 
set batch_train=false

:: The number of images to use for training when batch_train is true. 1 means 2 images(0, 1). 
set max_num=2

:: Pretrained model path. The path to the base model to use for training. 
set model_path="C:\v1-5-pruned-emaonly.ckpt"


:: Root path. Remove numbers from the folder's name if batch_train is true. Example: oirginal_0 -> original. Multiple folders will be processed in numerical order. 
:: The path you enter must be the parent of the img folder. example : original/img

:: Path of the original image 
set root_a_path="C:\train\a"

:: Path of the edited image 
set root_b_path="C:\train\b"

:: The path where the output is stored when batch_train is true.
set batch_path="C:\train\batch"

:: sample prompt .txt location
set sample_prompt="C:\train\sample_prompt.txt"


::=========================================================================================::

:: Original paths
set root_a_path_org=%root_a_path%
set root_b_path_org=%root_b_path%

:: Loop count
set current_num=0

:START_TRAIN

IF "%batch_train%" equ "true" (
    set root_a_path=!!root_a_path_org:"=!!_%current_num%
    set root_b_path=!!root_b_path_org:"=!!_%current_num%
    echo Batch train Start!
    echo !root_a_path!
    echo !root_b_path!
)

:: Paths for training and output
set train_dir_a="%root_a_path%\img"
set out_dir_a="%root_a_path%\model"
set log_dir_a="%root_a_path%\log"
set output_name_a="model_original"
set lora_dir_a="%out_dir_a%\%output_name_a%.safetensors"
call set lora_dir_a="%%lora_dir_a:"=%%"

set train_dir_b="%root_b_path%\img"
set out_dir_b="%root_b_path%\model"
set log_dir_b="%root_b_path%\log"
set output_name_b="model_edited"
set lora_dir_b="%out_dir_b%\%output_name_b%.safetensors"
call set lora_dir_b="%%lora_dir_b:"=%%"

set merge_dir=%out_dir_a%\%output_name_a%_merge.safetensors
call set merge_dir=%%merge_dir:"=%%

:: Train LoRA A
call :train_network %model_path% %train_dir_a% %out_dir_a% %log_dir_a% %output_name_a%

:: Merge LoRA A to source model
:: Use merge_model for sd 1.5, or merge_model_xl for sdxl. 
call :merge_model %model_path% %merge_dir% %lora_dir_a%

:: Train LoRA B
call :train_network %merge_dir% %train_dir_b% %out_dir_b% %log_dir_b% %output_name_b%

:: Delete merged model
del %merge_dir%

:: Loop train
IF "%batch_train%" equ "true" (
    rename %lora_dir_b% %current_num%.safetensors
    xcopy %out_dir_b% %batch_path% /Y
    echo Saved model at: %batch_path%\%current_num%.safetensors
    echo Current batch num: %current_num%
    set /a current_num+=1
    IF %current_num% LSS %max_num% (GOTO :START_TRAIN)
)

pause
goto :eof


::=========================================================================================::

:: Function to train a network. 
::Edit this section to modify Lora training parameters. : https://github.com/kohya-ss/sd-scripts/blob/main/docs/train_network_README-ja.md
:train_network
:: Arguments: %1 = model_path, %2 = train_dir, %3 = out_dir, %4 = log_dir, %5 = output_name
:: Use "train_network.py" for sd 1.5, or "sdxl_train_network.py" for sdxl. 
accelerate launch --num_cpu_threads_per_process 2 "train_network.py" ^
--enable_bucket ^
--min_bucket_reso=64 ^
--max_bucket_reso=1024 ^
--pretrained_model_name_or_path=%~1 ^
--train_data_dir=%~2 ^
--resolution="512,512" ^
--output_dir=%~3 ^
--logging_dir=%~4 ^
--network_alpha=16 ^
--save_model_as=safetensors ^
--network_module=networks.lora ^
--network_dim=16 ^
--output_name=%~5 ^
--lr_scheduler_num_cycles="4" ^
--no_half_vae ^
--learning_rate="0.001" ^
--lr_scheduler="linear" ^
--bucket_no_upscale ^
--train_batch_size="8" ^
--max_train_steps=1000 ^
--mixed_precision="fp16" ^
--save_precision="fp16" ^
--cache_latents ^
--optimizer_type="AdamW8bit" ^
--max_data_loader_n_workers="12" ^
--persistent_data_loader_workers ^
--bucket_reso_steps=64 ^
--xformers ^
--gradient_checkpointing ^
--bucket_no_upscale ^
--network_train_unet_only ^
--seed=42 ^
--console_log_simple ^
--sample_sampler=euler_a ^
--sample_prompts=%sample_prompt% ^
--sample_every_n_steps=100
goto :eof


:: Function to merge LoRA model to base model. 
:: After the original LORA is trained, it is merged into the base model, and then the modified LORA is trained with the merged model. The merged model is automatically deleted.  
:merge_model
:: Arguments: %1 = model_path, %2 = merge_dir, %3 = lora_dir
"networks/merge_lora.py" --sd_model %~1 --save_precision fp16 --precision float --save_to %~2 --models %~3 --ratios 1
goto :eof

:merge_model_xl
:: Arguments: %1 = model_path, %2 = merge_dir, %3 = lora_dir
"networks/sdxl_merge_lora.py" --sd_model %~1 --save_precision fp16 --precision float --save_to %~2 --models %~3 --ratios 1
goto :eof
