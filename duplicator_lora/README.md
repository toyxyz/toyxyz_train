# Duplicator_lora tools

Small batch files to help you learn Duplicator lora.

Use it with kohya-ss/sd-scripts. 

https://github.com/kohya-ss/sd-scripts

Put these batch files in the sd-scripts folder. 

## Run_duplicator.bat

Train the lora using image a, then merge it into the base model, train image b on the merged model, and make the difference between image a and image b lora.

You can train multiple LORAs sequentially with batch_train. 

## Prepare_Duplicator_Dataset.bat

Copy and arrange the images into the structure needed to train Lora. 

## Merge_loras.bat

Merge multiple LORAs. The merge ratio is automatically calculated. Merging multiple duplicator LORAs of the same subject can increase the flexibility of the LORA. 
