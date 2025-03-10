import torch

model = torch.load('/users/eleves-b/2022/martin.beaufils/CrowdCounting/C-3-Framework/exp/03-05_18-53_DroneCrowd_Res101_SFCN_1e-05/latest_state.pth')

print(model.keys())
print(model['epoch'])
print(model['train_record'])
