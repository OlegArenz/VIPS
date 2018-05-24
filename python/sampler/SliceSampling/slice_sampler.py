import numpy as np
import time

"""
Python code is taken from http://isaacslavitt.com/2013/12/30/metropolis-hastings-and-slice-sampling/ 
and was slightly modified to save progress
"""
def slice_sample(lnpdf, init, iters, sigma, step_out=True):
    """
    based on http://homepages.inf.ed.ac.uk/imurray2/teaching/09mlss/
    """

    fevals = []
    timestamps = []

    # set up empty sample holder
    D = len(init)
    samples = np.zeros((D, iters))

    # initialize
    xx = init.copy()

    for i in range(iters):
        if i % 10000 == 0:
            fevals.append(lnpdf.counter)
            timestamps.append(time.time())
        perm = range(D)
        np.random.shuffle(list(perm))
        last_llh = lnpdf(xx)

        for d in perm:
            llh0 = last_llh + np.log(np.random.rand())
            rr = np.random.rand(1)
            x_l = xx.copy()
            x_l[d] = x_l[d] - rr * sigma[d]
            x_r = xx.copy()
            x_r[d] = x_r[d] + (1 - rr) * sigma[d]

            if step_out:
                llh_l = lnpdf(x_l)
                while llh_l > llh0:
                    x_l[d] = x_l[d] - sigma[d]
                    llh_l = lnpdf(x_l)
                llh_r = lnpdf(x_r)
                while llh_r > llh0:
                    x_r[d] = x_r[d] + sigma[d]
                    llh_r = lnpdf(x_r)

            x_cur = xx.copy()
            while True:
                xd = np.random.rand() * (x_r[d] - x_l[d]) + x_l[d]
                x_cur[d] = xd.copy()
                last_llh = lnpdf(x_cur)
                if last_llh > llh0:
                    xx[d] = xd.copy()
                    break
                elif xd > xx[d]:
                    x_r[d] = xd
                elif xd < xx[d]:
                    x_l[d] = xd
                else:
                    raise RuntimeError('Slice sampler shrank too far.')

        if i % 1000 == 0: print('iteration' +str(i))

        samples[:, i] = xx.copy().ravel()

    return [samples, np.array(fevals), np.array(timestamps)]