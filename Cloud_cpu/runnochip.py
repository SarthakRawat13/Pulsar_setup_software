from main import AIRUN
import argparse

parser = argparse.ArgumentParser()
parser.add_argument('--model','-m',type=str,default="/home/user/Jamie/code/DISA/models/S.tflite",help='Model to run')
parser.add_argument('--uint',action='store_true',help='Import data directly')
parser.add_argument('--reversed','-r',action='store_true',help='Use NHWC instead of NCHW ordering')
parser.add_argument('--data',type=str,default='/home/user/Jamie/data/validation',help='Directory path containing test data')
args = parser.parse_args()

ob1 = AIRUN()
args.reversed = False
ob1.runcpu(args.model,args.data,args.reversed,args.uint,shape=224)
