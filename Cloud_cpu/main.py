import numpy as np
from sklearn.metrics import precision_recall_fscore_support
import os
from PIL import Image
import time
from torchvision import transforms, datasets
import torch
import tflite_runtime.interpreter as tflite


loading_times = 0

class AIRUN:
    def load_classes(self, data_dir):
        return sorted(os.listdir(data_dir))
    
    def gen_t_data(self, data_dir, shape=224):
        preprocess = transforms.Compose([
                transforms.Resize(256),
                transforms.CenterCrop(shape),
                transforms.ToTensor(),
                transforms.Normalize([0.485, 0.456, 0.406], [0.229, 0.224, 0.225])
            ])
        data = datasets.ImageFolder(data_dir, preprocess)
        dataloaders = torch.utils.data.DataLoader(data,batch_size=1,shuffle=True, num_workers=0)
        return dataloaders

    def get_data(self, data_dir,shape = 224):
        loading_times = 0
        start = time.time()
        cats = sorted(os.listdir(data_dir))
        for cat_num,cat in enumerate(cats):
            files = os.listdir(os.path.join(data_dir,cat))
            for f in files:
                fp = os.path.join(data_dir,cat,f)
                raw_image = np.asarray(Image.open(fp))
                offset = int((256 - shape) / 2)
                cropped_image = raw_image[offset:256-offset,offset:256-offset]
                preprocessed_image = np.expand_dims(cropped_image,0)
                end = time.time()
                loading_times += end-start
                yield [preprocessed_image,[cat_num,]]


    def runcpu(self, model_fn,data_dir,reversed=True, use_int8_data=True, shape = 224):
        interpreter = tflite.Interpreter(model_path=model_fn)
        interpreter.allocate_tensors()
        input_details = interpreter.get_input_details()
        output_details = interpreter.get_output_details()
        total_time = time.time()
        data = self.get_data(data_dir,shape)
        datalen = 0
        for _,_,fs in os.walk(data_dir):
            for f in fs:
                datalen+=1
        y_pred = np.ndarray(datalen,dtype=np.uint8)
        y_true = np.ndarray(datalen,dtype=np.uint8)
        i = 0
        data_type = input_details[0]['dtype']
        d_count = 0
        for x,y in data:
            d_count += 1
            y_true[i] = np.asarray(y)[0]
            tensor = x
            if reversed:
                tensor = np.transpose(tensor,(0,2,3,1))
            if data_type != tensor.dtype:
                tensor = tensor.astype(data_type)
            interpreter.set_tensor(input_details[0]['index'],tensor)
            interpreter.invoke()
            output = interpreter.get_tensor(output_details[0]['index'])
            prediction = output.argmax(1)
            y_pred[i] = prediction
            i+=1

        correct = (y_pred == y_true)
        accuracy = correct.sum() / correct.size
        labels = [i for i in range(len(self.load_classes(data_dir)))]
        pr,rc,fscore,_ = precision_recall_fscore_support(y_pred, y_true,labels=labels,average='macro',zero_division=0)
        total_time = time.time() - total_time

        print("Total Time: ",total_time)
        print("FPS: ", d_count/total_time)
        print("Accuracy: {:.4f}".format(accuracy))
        print("Precision: {:.4f}".format(pr))
        print("Recall: {:.4f}".format(rc))
        print("F1-Score: {:.4f}".format(fscore))



