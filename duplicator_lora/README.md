# Duplicator_lora tools

Small batch files to help training Duplicator lora.

About Duplicator lora : https://note.com/2vxpswa7/n/n2d04527bf0bc

Use it with kohya-ss/sd-scripts. 

https://github.com/kohya-ss/sd-scripts

Put these batch files in the sd-scripts folder. 

Each batch file must be modified with the path and parameters of the dataset you prepared before running it. 

## Run_duplicator.bat

Train the lora using image a, then merge it into the base model, train image b on the merged model, and make the difference between image a and image b lora.

For example, you can create a greenscreen Lora using a normal image A and an image B with a greenscreen background. 

You can train multiple LORAs sequentially with batch_train. 

![image](https://github.com/user-attachments/assets/f465e755-2a0e-4233-a882-623a0932758f)

Use "train_network.py" for sd 1.5, or "sdxl_train_network.py" for sdxl.

![image](https://github.com/user-attachments/assets/c3c73526-ef40-4b97-a87a-bc1a993dd232)


Use merge_model for sd 1.5, or merge_model_xl for sdxl.

![image](https://github.com/user-attachments/assets/338273ef-95d4-4bec-929d-32dd75e2e3ca)


## Prepare_Duplicator_Dataset.bat

Copy and arrange the images into the structure needed to train Lora. 

![image](https://github.com/user-attachments/assets/4388f474-627b-4d04-8d7d-540d48df6997)

If multi_size is true, the image will be duplicated in sizes of 1.0x, 0.75x, 0.5x. 
To use multi_size, you need to install imagemagick and register it in your PATH. https://imagemagick.org/script/download.php

![image](https://github.com/user-attachments/assets/6ac3aada-7027-43c3-8ca6-0ac1f8861d1b)

If the image has a caption(.txt). set use_tag to true. Must be the same name as the image. 

![image](https://github.com/user-attachments/assets/1c1ecef6-c48a-444b-bf68-b9050732e05a)



## Merge_loras.bat

Merge multiple LORAs. The merge ratio is automatically calculated. Merging multiple duplicator LORAs of the same subject can increase the flexibility of the LORA. 
