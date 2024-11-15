# Duplicator_lora tools

Small batch files to help training Duplicator lora.

About Duplicator lora : https://note.com/2vxpswa7/n/n2d04527bf0bc

Use it with kohya-ss/sd-scripts. 

https://github.com/kohya-ss/sd-scripts

Put these batch files in the sd-scripts folder. 

## Run_duplicator.bat

Train the lora using image a, then merge it into the base model, train image b on the merged model, and make the difference between image a and image b lora.

You can train multiple LORAs sequentially with batch_train. 

![image](https://github.com/user-attachments/assets/f465e755-2a0e-4233-a882-623a0932758f)


## Prepare_Duplicator_Dataset.bat

Copy and arrange the images into the structure needed to train Lora. 

![image](https://github.com/user-attachments/assets/4388f474-627b-4d04-8d7d-540d48df6997)


## Merge_loras.bat

Merge multiple LORAs. The merge ratio is automatically calculated. Merging multiple duplicator LORAs of the same subject can increase the flexibility of the LORA. 
