import torch.nn as nn
import torch
import torch.nn.functional as F

class MLP(nn.Module):
    def __init__(self, input_size=6220800):
        super(MLP, self).__init__()
        self.fc1 = nn.Linear(input_size, 128) 
        self.fc2 = nn.Linear(128, 1)

    def forward(self, x):
        x = x.view(x.size(0), -1)
        x = F.relu(self.fc1(x))
        x = self.fc2(x)
        return x