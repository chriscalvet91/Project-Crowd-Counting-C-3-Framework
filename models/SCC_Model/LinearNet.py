import torch.nn as nn
import torch
import torch.nn.functional as F

class LinearNet(nn.Module):
    def __init__(self, input_size=2359296):
        super(LinearNet, self).__init__()
        self.fc1 = nn.Linear(input_size, 1) 

    def forward(self, x):
        x = x.view(x.size(0), -1)
        x = self.fc1(x)
        return x