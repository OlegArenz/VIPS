import numpy as np
from plotting.visualize_n_link import visualize_mixture
import matplotlib.pyplot as plt

# gt = np.load("/data/jmlrtmp/learnToSample/data/groundtruth/10link/icml_10link_samples_10kof25.6mio.npz")
# plt.figure(1)
# visualize_mixture(np.ones(200), gt['arr_0'][::50], l=None, clear_fig=True, markerPoses=[[7,0]])
# plt.xlim([-0.5,7.5])
# plt.ylim([-4,4])
# plt.savefig("/tmp/10link_gt.pdf", bbox_inches="tight", pad_inches=0)
#
# learned = np.load('/data/jmlr/learnToSample/data/experiments/10link/vipsEM1_incomp/fast_adding/init_50/1/gmm_dump_340.npz')
# plt.figure(2)
# visualize_mixture(learned['weights'], learned['means'], l=None, clear_fig=True, markerPoses=[[7,0]])
# plt.xlim([-0.5,7.5])
# plt.ylim([-4,4])
# plt.savefig("/tmp/10link_learned.pdf", bbox_inches="tight", pad_inches=0)
#
# gt = np.load('/data/jmlrtmp/learnToSample/data/groundtruth/10link_4/samples_10link4_180kof200M.npy')[:,::18,:].reshape((-1,10)).copy()
# plt.figure(3)
# visualize_mixture(np.ones(200), gt[::50], l=None, clear_fig=True, markerPoses=[[-7,0],[7,0],[0,-7],[0,7]])
# plt.xlim([-7.5,7.5])
# plt.ylim([-7.5, 7.5])
# plt.savefig("/tmp/10link4_gt.pdf", bbox_inches="tight", pad_inches=0)
#
# learned = np.load('/data/jmlr/learnToSample/data/experiments/10link_4p/vipsEM1/fast_adding/init_100/1/gmm_dump_490.npz')
# plt.figure(4)
# visualize_mixture(learned['weights'], learned['means'], l=None, clear_fig=True, markerPoses=[[-7,0],[7,0],[0,-7],[0,7]])
# plt.xlim([-7.5,7.5])
# plt.ylim([-7.5, 7.5])
# plt.savefig("/tmp/10link4_learned.pdf", bbox_inches="tight", pad_inches=0)


from plotting.TwoD_plots import TwoD_plots
from experiments.lnpdfs.create_target_lnpfs import build_target_likelihood_planar_n_link
num_dimensions=10
conf_likelihood_var = 4e-2 * np.ones(num_dimensions)
conf_likelihood_var[0] = 1e0
cart_likelihood_var = np.array([1e-4, 1e-4])
target_lnpdf =  build_target_likelihood_planar_n_link(num_dimensions, conf_likelihood_var, cart_likelihood_var)[0]

gt_sample = np.load("/data/jmlrtmp/learnToSample/data/groundtruth/10link/icml_10link_samples_10kof25.6mio.npz")['arr_0'][0]
def twoDTarget(x):
    inp = gt_sample
    inp[-2:] = x
    return target_lnpdf(inp)

plotter2 = TwoD_plots(target_lnpdf=twoDTarget, min_x=-5, max_x=5, num_x=100, min_y=-5, max_y=5, num_y=100)
plotter2.plot_target(None, plotLog=True)

learned = np.load('/data/jmlr/learnToSample/data/experiments/10link/vipsEM1_incomp/fast_adding/init_50/1/gmm_dump_340.npz')
from experiments.GMM import GMM
gmm = GMM(10)
for m,c in zip(learned['means'], learned['covs']):
    gmm.add_component(m, c)
gmm.set_weights(learned['weights'])
def twoDLearned(x):
    inp = gt_sample
    inp[-2:] = x
    return gmm.evaluate(np.atleast_2d(inp), return_log=True)
plotter = TwoD_plots(target_lnpdf=twoDLearned, min_x=-5, max_x=5, num_x=100, min_y=-5, max_y=5, num_y=100)
plotter.plot_target(None, plotLog=True)

print("done")