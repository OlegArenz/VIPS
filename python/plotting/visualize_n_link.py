import numpy as np
import matplotlib.pyplot as plt
import matplotlib.patches as patches
plt.ion()

def visualize_samples(samples, thinning=1, create_figure=True):
    if create_figure:
        plt.figure()
    [num_samples, num_dimensions] = samples.shape
    for i in range(0, num_samples, thinning):
        visualize_n_link(samples[i], num_dimensions, np.ones(num_dimensions))

def animate_n_link(input, index=1, lengths=None):
    plt.clf()
    states= input.copy()
    n = len(states[0][::2])
    if lengths is None:
        lengths = np.ones(n)
    fig, ax = plt.subplots(num=index)
    ax.set_xlim(-2, 2)
    ax.set_ylim(-2, 2)
    ax.set_aspect('equal', 'box')
    line1, = ax.plot([0,0], [0,0], color='k', linestyle='-', linewidth=2)
    line2, = ax.plot([0,0], [0,0], color='k', linestyle='-', linewidth=2)
    lines = [line1, line2]
    text = ax.text(-1.75, 1.7, "T = 0")
    plt.show(block=False)
    fig.canvas.draw()
    for t in range(states.shape[0]):
        # start1 = time.time()
        theta = states[t][::2]
        theta[0] += np.pi / 2
        x = [0]
        y = [0]
        # start2 = time.time()
        for i in range(0, n):
            y.append(y[-1] + lengths[i] * np.sin(np.sum(theta[:i + 1])))
            x.append(x[-1] + lengths[i] * np.cos(np.sum(theta[:i + 1])))
            lines[i].set_xdata([x[-2], x[-1]])
            lines[i].set_ydata([y[-2], y[-1]])
        # fragt = time.time() - start2
        text.set_text("T = {}".format(t))
        ax.draw_artist(ax.patch)
        ax.draw_artist(line1)
        ax.draw_artist(line2)
        plt.pause(0.01)

def visualize_n_link(theta, num_dimensions, l, clear_fig=True):
    if clear_fig:
        plt.clf()
    plt.xlim([-0.2*num_dimensions,num_dimensions])
    plt.ylim([-0.5*num_dimensions,0.5*num_dimensions])
   # plt.plot([-num_dimensions,num_dimensions],[1,1], color='r', linestyle='-.')

    x = [0]
    y = [0]
    for i in range(0, num_dimensions):
        y.append(y[-1] + l[i] * np.sin(np.sum(theta[:i+1])))
        x.append(x[-1] + l[i] * np.cos(np.sum(theta[:i+1])))
        plt.plot([x[-2], x[-1]], [y[-2],y[-1]], color='k', linestyle='-', linewidth=2)
    plt.plot(x[-1], y[-1], 'o')
    plt.plot(0.7*num_dimensions,0, 'rx')
    plt.pause(0.1)

def visualize_mixture(mixture_weights, mixture_means, l=None, clear_fig=True, markerPoses=[]):
    num_dimensions = len(mixture_means[0])
    if l is None:
        l = np.ones(num_dimensions)
    if clear_fig:
        plt.clf()

    plt.xlim([-0.2 * num_dimensions, num_dimensions])
    plt.ylim([-0.5 * num_dimensions, 0.5 * num_dimensions])
    plt.xlim([ -num_dimensions,num_dimensions])
    plt.ylim([-num_dimensions,num_dimensions])
    # plt.plot([-num_dimensions,num_dimensions],[1,1], color='r', linestyle='-.')
    if np.max(mixture_weights) - np.min(mixture_weights) != 0:
        weights = mixture_weights - np.min(mixture_weights)
        weights = 0.1 + 0.9 * weights / (np.max(weights) - np.min(weights))
    else:
        weights = np.ones((len(mixture_weights)))


    for weight, theta in zip(weights, mixture_means):
        x = [0]
        y = [0]
        for i in range(0, num_dimensions):
            y.append(y[-1] + l[i] * np.sin(np.sum(theta[:i+1])))
            x.append(x[-1] + l[i] * np.cos(np.sum(theta[:i+1])))
            plt.plot([x[-2], x[-1]], [y[-2],y[-1]], color='k', linestyle='-', linewidth=2, alpha=weight, markersize=3)
        plt.plot(x[-1], y[-1], 'o', color="k", alpha=weight, markersize=6.1)
        plt.plot(x[-1], y[-1], 'o', color="red", alpha=weight, markersize=6)
    rect = patches.Rectangle((-0.25, -0.25), 0.5, 0.5, linewidth=1, edgecolor='k', fill=True, facecolor='dimgrey',
                             zorder=1000)
    ax = plt.gca()
    ax.add_patch(rect)
    [plt.plot(pose[0], pose[1], 'rx', markersize=10, mew=2) for pose in markerPoses]


