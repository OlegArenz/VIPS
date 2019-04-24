import matplotlib.pyplot as plt
import numpy as np
plt.ion()

def default_plots_progress(progress):
    # Plot KLs
    # plt.figure(1)
    # plt.clf()
    # plt.subplot(211)
    # plt.title('KL weights')
    # try:
    #     plt.semilogy(np.array(progress.kl_weights))
    # except:
    #     print("error with kl_weights_history")
    # plt.subplot(212)
    # plt.title('KL_components')
    # plt.plot(progress.kl_components[-1])

    # plot weights
    plt.figure(2)
    plt.clf()
    plt.title("Weights")
    weights = progress.weights[-1]
    plt.semilogy(weights, 'x')

    # plot expected rewards
   # if (len(progress.expected_rewards) > 0):
   #     plt.figure(3)
   #     plt.clf()
   #     plt.title("expected rewards")
   #     plt.plot(progress.expected_rewards[-1])
   #     plt.plot(progress.expected_target_densities[-1])

    # plot number of components
    plt.figure(3)
    plt.clf()
    plt.title("number of components")
    plt.plot(progress.num_components)

    # plot updates per component
    #plt.figure(5)
    #plt.plot(progress.num_updates_per_component[-1])



    # plot MMD
    if len(progress.mmd) > 0:
        plt.figure(5)
        plt.clf()
        plt.title("MMD")
        plt.semilogy(progress.mmd)

   # plot reward histories
    comp_cost = progress.comp_reward_history
    if comp_cost is not None and len(comp_cost) > 0:
        plt.figure(6)
      #  plt.clf()
        plt.title("Component Reward")
        plt.plot(progress.comp_reward_history)
 #       comp_cost = -progress.comp_reward_history
 #       if (np.min(comp_cost) < 0):
 #           comp_cost += np.min(comp_cost) + 1e-10
 #       try:
 #           plt.semilogy(comp_cost)
 #       except:
 #           print("could not plot reward on logscale")

    # plot estimated GMM entropy
    # plt.figure(9)
    # plt.title("estimated GMM entropy")
    # plt.plot(progress.gmm_entropy)
    # plt.plot(progress.desired_entropy)
    plt.show()
    plt.pause(0.00001)

def default_plots(sampler):
    # plot groundtruth densities on mixture
    if sampler.groundtruth_samples is not None:
        plt.figure(4)
        plt.clf()
        plt.title("Densities of groundtruth samples under learned mixture")
        densities_on_gt = sampler.vips_c.get_log_densities_on_mixture(sampler.groundtruth_samples)
        plt.plot(sampler.progress.target_densities_on_gt - np.max(sampler.progress.target_densities_on_gt), '.')
        plt.plot(densities_on_gt - np.max(densities_on_gt), 'x')

    plt.figure(12)
    plt.clf()
    num_sample_history = sampler.vips_c.get_debug_info()[10].T
    for i in range(len(num_sample_history)):
        trimmed = np.trim_zeros(num_sample_history[i], 'f')
        plt.plot(np.arange(num_sample_history.shape[1]-len(trimmed)+1,num_sample_history.shape[1]+1), trimmed, linewidth=1.5)
    plt.pause(0.01)
    default_plots_progress(sampler.progress)



