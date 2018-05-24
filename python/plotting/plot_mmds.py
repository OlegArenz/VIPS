import matplotlib.pyplot as plt
import os
import numpy as np
from scipy.interpolate import interp1d

plt.ion()


import matplotlib
N_curves = 15
colormap = matplotlib.cm.get_cmap(name="gist_rainbow", lut=N_curves)

color_idx=0
vips_linestyle='-'
vips_color=colormap(color_idx/N_curves)

color_idx+=1
vboost1_linestyle='-'
vboost1_color=colormap(color_idx/N_curves)

color_idx+=1
svgd_linestyle="--"
svgd_color=colormap(color_idx/N_curves)

color_idx+=1
slice_linestyle='-'
slice_color=colormap(color_idx/N_curves)

color_idx+=1
vboost5_linestyle='-'
vboost5_color=colormap(color_idx/N_curves)

color_idx+=1
ess_linestyle='-'
ess_color=colormap(color_idx/N_curves)

color_idx+=1
vboost0_linestyle='--'
vboost0_color=colormap(color_idx/N_curves)

color_idx+=1
ptmcmc_linestyle="--"
ptmcmc_color=colormap(color_idx/N_curves)

color_idx+=1
npvi_linestyle='-'
npvi_color=colormap(color_idx/N_curves)

color_idx+=1
hmc_linestyle='-.'
hmc_color=colormap(color_idx/N_curves)

color_idx+=1
vboost10_linestyle='-.'
vboost10_color=colormap(color_idx/N_curves)

color_idx+=1
ptmcmc_linestyle="--"
ptmcmc_color=colormap(color_idx/N_curves)

color_idx+=1
vipsS_linestyle='--'
vipsS_color=colormap(color_idx/N_curves)

color_idx+=1
vboost20_linestyle='-.'
vboost20_color=colormap(color_idx/N_curves)


def plot_mmd(basepath, plot_over_time=False, figureId=None, average_plots=False, plot_individuals=False, name_filter='', x_start=10000, use_vboost_hack=False, linestyle='-', color=None):
    if figureId == None:
        plt.figure
    else:
        plt.figure(figureId)
    #plt.xscale('log')
    plt.yscale('log')
    plt.ylabel('MMD', fontsize=14)
    plt.title(basepath)
    interpolations = []
    x = []
    D = None
    min_xs = []
    max_xs = []
    handles = []
    fnames=[]
    for dirName, subdirList, fileList in os.walk(basepath):
        for fname in sorted(fileList):
            if 'processed_data_with_mmd' in fname and name_filter in fname:
                data = np.load(dirName + "/" + fname)
                mmds = data['mmds']
                if plot_over_time:
                    x = data['timestamps']
                    plt.xlabel('time [s]', fontsize=14)
                else:
                    x = data['fevals']
                    if use_vboost_hack:
                        if D is None:
                            D = data['samples'].shape[-1]
                        diff = np.maximum(0, (np.min(x) - 5 * 1000 * D))
                        x -= diff
                    plt.xlabel('function evaluations', fontsize=14)
                interpolations.append(interp1d(x, mmds))
                fnames.append(fname)
                min_xs.append(np.min(x))
                max_xs.append(np.max(x))

               # if not average_plots:
               #     plt.plot(x,mmds)
               #     plt.pause(0.00001)
    curves = []
    xs = np.linspace(np.maximum(x_start,np.max(min_xs)), np.min(max_xs), 100)

    for j in range(len(interpolations)):
        curves.append(interpolations[j](xs))
        if plot_individuals:
            myxs = np.linspace(np.maximum(min_xs[j],x_start), max_xs[j], 100)
            handles.append(plt.plot(myxs, curves[j]))
    if average_plots:
        if color is not None:
            plt.fill_between(xs, np.min(np.array(curves), axis=0), np.max(np.array(curves), axis=0), alpha=0.1,
                             color=color)
            return plt.plot(xs,  np.mean(np.array(curves), axis=0), linestyle=linestyle, color=color)
        else:
            plt.fill_between(xs, np.min(np.array(curves), axis=0), np.max(np.array(curves), axis=0), alpha=0.1)
            return plt.plot(xs,  np.mean(np.array(curves), axis=0), linestyle=linestyle)
    return handles


def draw_3dplot(id, xlog=False):
    plt.figure(id)
    if(xlog):
        plt.xscale('log')
    #svgd_plot = plot_mmd("/data/icml/learnToSample/data/ICML/3link/svgd", figureId=id, average_plots=False, plot_individuals=True,
    #         name_filter='0.001')[0]
    svgd_plot = plot_mmd("/data/icml/learnToSample/data/ICML/3link/svgd/run2", figureId=id, average_plots=True,
                         plot_individuals=False,name_filter='',linestyle=svgd_linestyle, color=svgd_color)
    vips_plot = plot_mmd("/data/icml/learnToSample/data/ICML/3link/vips/run3/explorative", figureId=id, average_plots=True,
             plot_individuals=False, name_filter='', linestyle=vips_linestyle, color=vips_color)
    ess_plot = plot_mmd("/data/icml/learnToSample/data/ICML/3link/ess", figureId=id, average_plots=True, plot_individuals=False, name_filter='', linestyle=ess_linestyle, color=ess_color)
    ptmcmc_plot = plot_mmd("/data/icml/learnToSample/data/ICML/3link/ptmcmc/8chain", figureId=id, average_plots=True,
             plot_individuals=False, name_filter='', linestyle=ptmcmc_linestyle, color=ptmcmc_color)
    leg = plt.legend([svgd_plot[0], vips_plot[0], ess_plot[0], ptmcmc_plot[0]], ['svgd', 'vips', 'ess', 'ptmcmc'])
    leg.draggable()
   # plt.title('MMD (3 Link)')



def draw_10dplot(id, xlog=False):
    plt.figure(id)
    plt.title('MMD (10 Link)')
    if (xlog):
        plt.xscale('log')
    svgd_plot = plot_mmd("/data/icml/learnToSample/data/ICML/10link/svgd/run2", figureId=id, average_plots=True, plot_individuals=False,
             name_filter='0.0005', linestyle=svgd_linestyle, color=svgd_color)
    plt.title('MMD (10 Link)')
    vips_plot =  plot_mmd("/data/icml/learnToSample/data/ICML/10link/vips/run3/explorative", figureId=id, average_plots=True,
             plot_individuals=False,name_filter='', linestyle=vips_linestyle, color=vips_color)
    ess_plot = plot_mmd("/data/icml/learnToSample/data/ICML/10link/ess", figureId=id, average_plots=True, plot_individuals=False,
         name_filter='', linestyle=ess_linestyle, color=ess_color)
 #   vboost0_plot = plot_mmd("/data/icml/learnToSample/data/ICML/10link/vboost/run1/rank0", figureId=id, average_plots=True, plot_individuals=False,
 #        name_filter='', use_vboost_hack=True, linestyle=vboost0_linestyle, color=vboost0_color)
 #   vboost1_plot = plot_mmd("/data/icml/learnToSample/data/ICML/10link/vboost/run1/rank1", figureId=id, average_plots=True, plot_individuals=False,
 #        name_filter='', use_vboost_hack=True, linestyle=vboost1_linestyle, color=vboost1_color)
 #   vboost5_plot = plot_mmd("/data/icml/learnToSample/data/ICML/10link/vboost/run1/rank5", figureId=id, average_plots=True, plot_individuals=False,
 #        name_filter='', use_vboost_hack=True, linestyle=vboost5_linestyle, color=vboost5_color)
    vboost10_plot = plot_mmd("/data/icml/learnToSample/data/ICML/10link/vboost/run1/rank10", figureId=id, average_plots=True, plot_individuals=False,
         name_filter='', use_vboost_hack=True, linestyle=vboost10_linestyle, color=vboost10_color)

    #ptmcmc_plot = plot_mmd("/data/icml/learnToSample/data/ICML/10link/ptmcmc/", figureId=id, average_plots=True,
    #                   plot_individuals=False, name_filter='')
    ptmcmc_plot = plot_mmd("/data/icml/learnToSample/data/ICML/10link/ptmcmc/run2/8chains", figureId=id, average_plots=True,
                       plot_individuals=False, name_filter='')
    slice_plot = plot_mmd("/data/icml/learnToSample/data/ICML/10link/slice", figureId=id, average_plots=True, plot_individuals=False,
             name_filter='', linestyle=slice_linestyle, color=slice_color)
    npvi_plot = plot_mmd("/data/icml/learnToSample/data/ICML/10link/npvi/run", figureId=2, average_plots=True, plot_individuals=False,
         name_filter='', use_vboost_hack=True, linestyle=npvi_linestyle, color=npvi_color)

 #   plt.title('MMD (10 Link)')
    leg = plt.legend([svgd_plot[0], vips_plot[0], ess_plot[0], ptmcmc_plot[0], slice_plot[0], npvi_plot[0],
                vboost10_plot[0]],
               ['svgd', 'vips', 'ess', 'ptmcmc', 'slice','npvi',
                'vboost10' ])
    leg.draggable()
    plt.figure()

def draw_gmmplot(id, xlog=False, plot_over_time=False, x_start=10000):
    plt.figure(id)
    if (xlog):
        plt.xscale('log')
    svgd_plot = plot_mmd("/data/icml/learnToSample/data/ICML/gmm/svgd", figureId=id, average_plots=False, plot_individuals=True,
             name_filter='0.005', plot_over_time=plot_over_time, x_start=x_start, linestyle=svgd_linestyle, color=svgd_color)[0]
    vips_plot = plot_mmd("/data/icml/learnToSample/data/ICML/gmm/vips/run4_MT", figureId=id, average_plots=True,
             plot_individuals=False,name_filter='', plot_over_time=plot_over_time, x_start=x_start, linestyle=vips_linestyle, color=vips_color)
    ess_plot = plot_mmd("/data/icml/learnToSample/data/ICML/gmm/ess", figureId=id, average_plots=True, plot_individuals=False,
         name_filter='', plot_over_time=plot_over_time, x_start=x_start, linestyle=ess_linestyle, color=ess_color)
    ptmcmc_plot = plot_mmd("/data/icml/learnToSample/data/ICML/gmm/ptmcmc/8chains", figureId=id, average_plots=True,
                       plot_individuals=False, name_filter='', plot_over_time=plot_over_time, x_start=x_start, linestyle=ptmcmc_linestyle, color=ptmcmc_color)
    leg = plt.legend([svgd_plot[0], vips_plot[0], ess_plot[0], ptmcmc_plot[0]], ['svgd', 'vips', 'ess', 'ptmcmc'])
    leg.draggable()
  #  plt.title('MMD (GMM)')

def draw_gmm_time_plot(id, xlog=False, plot_over_time=True, x_start=0):
    plt.figure(id)
    if (xlog):
        plt.xscale('log')
    svgd_plot = plot_mmd("/data/icml/learnToSample/data/ICML/gmm/svgd", figureId=id, average_plots=False, plot_individuals=True,
             name_filter='0.005', plot_over_time=plot_over_time, x_start=x_start, linestyle=svgd_linestyle, color=svgd_color)[0]
    vips1_plot = plot_mmd("/data/icml/learnToSample/data/ICML/mttest/VIPS_MTtest1_gmm", figureId=id, average_plots=True,
             plot_individuals=False, name_filter='', plot_over_time=True, x_start=0, linestyle=vboost0_linestyle, color=vboost0_color)
    vips2_plot = plot_mmd("/data/icml/learnToSample/data/ICML/mttest/VIPS_MTtest2_gmm", figureId=id, average_plots=True,
             plot_individuals=False, name_filter='', plot_over_time=True, x_start=0, linestyle=vboost1_linestyle, color=vboost1_color)
    vips4_plot = plot_mmd("/data/icml/learnToSample/data/ICML/mttest/VIPS_MTtest4_gmm", figureId=id, average_plots=True,
             plot_individuals=False, name_filter='', plot_over_time=True, x_start=0, linestyle=vboost5_linestyle, color=vboost5_color)
    ess_plot = plot_mmd("/data/icml/learnToSample/data/ICML/gmm/ess", figureId=id, average_plots=True, plot_individuals=False,
         name_filter='', plot_over_time=plot_over_time, x_start=x_start, linestyle=ess_linestyle, color=ess_color)
    ptmcmc_plot = plot_mmd("/data/icml/learnToSample/data/ICML/gmm/ptmcmc/8chains", figureId=id, average_plots=True,
                       plot_individuals=False, name_filter='', plot_over_time=plot_over_time, x_start=x_start)
    leg = plt.legend([svgd_plot[0], vips1_plot[0], vips2_plot[0], vips4_plot[0], ess_plot[0], ptmcmc_plot[0]],
               ['svgd', 'vips (1 core)', 'vips (2 core)', 'vips (4 core)', 'ess', 'ptmcmc'])
    leg.draggable()
  #  plt.title('MMD (GMM) over time')

def draw_breast_cancer_plot(id, xlog=False):
    plt.figure(id)
    if (xlog):
        plt.xscale('log')

    vips_plot = plot_mmd("/data/icml/learnToSample/data/ICML/breast_cancer/vips/run4_MT/VIPS_breast_cancer_mt/explorative", figureId=id, average_plots=True,
             plot_individuals=False,name_filter='', linestyle=vips_linestyle, color=vips_color)
    vipsS_plot = plot_mmd("/data/icml/learnToSample/data/ICML/breast_cancer/vips/run3_rngNew/single_comp", figureId=id, average_plots=True,
             plot_individuals=False,name_filter='', linestyle=vipsS_linestyle, color=vipsS_color)
    ess_plot = plot_mmd("/data/icml/learnToSample/data/ICML/breast_cancer/ess", figureId=id, average_plots=True, plot_individuals=False,
         name_filter='', linestyle=ess_linestyle, color=ess_color)
    svgd_plot = plot_mmd("/data/icml/learnToSample/data/ICML/breast_cancer/svgd/run1", figureId=id, average_plots=False, plot_individuals=True,
                         name_filter='0.2', linestyle=svgd_linestyle, color=svgd_color)[0]
    npvi_plot = plot_mmd("/data/icml/learnToSample/data/ICML/breast_cancer/npvi", figureId=id, average_plots=True, plot_individuals=False,
         name_filter='', use_vboost_hack=True, linestyle=npvi_linestyle, color=npvi_color)
    leg = plt.legend([vipsS_plot[0], vips_plot[0], ess_plot[0], svgd_plot[0], npvi_plot[0]], ['vips1', 'vips40', 'ess', 'svgd', 'npvi'])
    leg.draggable()
   # plt.title('MMD (Breast Cancer)')

def draw_german_credit_plot(id, xlog=False):
    plt.figure(id)
    if (xlog):
        plt.xscale('log')

    vipsS_plot = plot_mmd("/data/icml/learnToSample/data/ICML/german_credit/vips/run3_rngNew/single_comp", figureId=id, average_plots=True,
             plot_individuals=False,name_filter='', linestyle=vipsS_linestyle, color=vipsS_color)
    vips_plot = plot_mmd("/data/icml/learnToSample/data/ICML/german_credit/vips/run4_home/explorative", figureId=id, average_plots=True,
             plot_individuals=False,name_filter='', linestyle=vips_linestyle, color=vips_color)
    svgd_plot = plot_mmd("/data/icml/learnToSample/data/ICML/german_credit/svgd/run1", figureId=id, average_plots=True, plot_individuals=False,
             name_filter='0.01', linestyle=svgd_linestyle, color=svgd_color)
    hmc_plot = plot_mmd("/data/icml/learnToSample/data/ICML/german_credit/hmc/run1/traj_100", figureId=id, average_plots=True, plot_individuals=False,
             name_filter='0.005',  linestyle=hmc_linestyle, color=hmc_color)
    ess_plot = plot_mmd("/data/icml/learnToSample/data/ICML/german_credit/ess/run1", figureId=id, average_plots=True, plot_individuals=False,
         name_filter='',  linestyle=ess_linestyle, color=ess_color)
    npvi_plot = plot_mmd("/data/icml/learnToSample/data/ICML/german_credit/npvi/run1", figureId=id, average_plots=True, plot_individuals=False,
         name_filter='', use_vboost_hack=True,  linestyle=npvi_linestyle, color=npvi_color)
    vboost0_plot = plot_mmd("/data/icml/learnToSample/data/ICML/german_credit/vboost/run1/rank0", figureId=5, average_plots=True,
             plot_individuals=False, name_filter='', use_vboost_hack=True, linestyle=vboost0_linestyle, color=vboost0_color)
  #  vboost1_plot = plot_mmd("/data/icml/learnToSample/data/ICML/german_credit/vboost/run1/rank1", figureId=5, average_plots=True,
  #           plot_individuals=False, name_filter='', use_vboost_hack=True, linestyle=vboost1_linestyle, color=vboost1_color)
    vboost5_plot = plot_mmd("/data/icml/learnToSample/data/ICML/german_credit/vboost/run1/rank5", figureId=5, average_plots=True,
             plot_individuals=False, name_filter='', use_vboost_hack=True, linestyle=vboost5_linestyle, color=vboost5_color)
    vboost10_plot = plot_mmd("/data/icml/learnToSample/data/ICML/german_credit/vboost/run1/rank10", figureId=5, average_plots=True,
             plot_individuals=False, name_filter='', use_vboost_hack=True, linestyle=vboost10_linestyle, color=vboost10_color)
  #  vboost20_plot = plot_mmd("/data/icml/learnToSample/data/ICML/german_credit/vboost/run1/rank20", figureId=5, average_plots=True,
  #           plot_individuals=False, name_filter='', use_vboost_hack=True, linestyle=vboost20_linestyle, color=vboost20_color)

    leg = plt.legend([vipsS_plot[0], vips_plot[0], svgd_plot[0], ess_plot[0], hmc_plot[0], npvi_plot[0],
                vboost0_plot[0], vboost5_plot[0], vboost10_plot[0]],
               ['vips1', 'vips40', 'svgd', 'ess', 'hmc', 'npvi',
                'vboost0','vboost5', 'vboost10'])
    leg.draggable()
    plt.title('')
 #   plt.title('MMD (German Credit)')

def draw_gmm40_plot(id, xlog=False):
    plt.figure(id)
    if (xlog):
        plt.xscale('log')

   # vips_plot = plot_mmd("/data/icml/learnToSample/data/ICML/breast_cancer/vips/run4_MT/VIPS_breast_cancer_mt/explorative", figureId=id, average_plots=True,
   #          plot_individuals=False,name_filter='')
    vipsS_plot = plot_mmd("/data/icml/learnToSample/data/ICML/gmm40/explorative40_2", figureId=id, average_plots=True,
             plot_individuals=False,name_filter='', linestyle=vipsS_linestyle, color=vipsS_color)
    leg = plt.legend([vipsS_plot[0]], ['vips 1'])
    leg.draggable()
 #   plt.title('MMD (GMM 40)')

def draw_iono_plot(id, xlog=False):
    plt.figure(id)
    if (xlog):
        plt.xscale('log')

   # vips_plot = plot_mmd("/data/icml/learnToSample/data/ICML/breast_cancer/vips/run4_MT/VIPS_breast_cancer_mt/explorative", figureId=id, average_plots=True,
   #          plot_individuals=False,name_filter='')
   # more1_plot = plot_mmd("/data/icml/learnToSample/data/ICML/iono/vips/run1", figureId=id, average_plots=True,
   #          plot_individuals=False,name_filter='')
    vipsS_plot = plot_mmd("/data/icml/learnToSample/data/ICML/iono/vips/run2", figureId=id, average_plots=True,
             plot_individuals=False,name_filter='')
    leg = plt.legend([vipsS_plot[0]], ['vips 1'])
    leg.draggable()
  #  plt.title('MMD (Ionosphere)')

def draw_frisk_plot(id, xlog=False):
    plt.figure(id)
    if (xlog):
        plt.xscale('log')

   # vips_plot = plot_mmd("/data/icml/learnToSample/data/ICML/breast_cancer/vips/run4_MT/VIPS_breast_cancer_mt/explorative", figureId=id, average_plots=True,
   #          plot_individuals=False,name_filter='')
    vipsS_plot = plot_mmd("/data/icml/learnToSample/data/ICML/frisk/vips/run1/single_comp", figureId=id, average_plots=True,
             plot_individuals=False,name_filter='', linestyle=vipsS_linestyle, color=vipsS_color)
    vips_plot = plot_mmd("/data/icml/learnToSample/data/ICML/frisk/vips/VIPS_frisk_mt/explorative_5", figureId=id,
                         average_plots=True, plot_individuals=False, name_filter='', linestyle=vips_linestyle, color=vipsS_color)
    svgd_plot = plot_mmd("/data/icml/learnToSample/data/ICML/frisk/svgd/run1", figureId=id, average_plots=False, plot_individuals=True,
             name_filter='0.005', linestyle=svgd_linestyle, color=svgd_color)
    hmc_plot = plot_mmd("/data/icml/learnToSample/data/ICML/frisk/hmc/run1/traj_50", figureId=id, average_plots=False, plot_individuals=True,
             name_filter='0.005', linestyle=hmc_linestyle, color=hmc_color)
    npvi_plot = plot_mmd("/data/icml/learnToSample/data/ICML/frisk/npvi", figureId=id, average_plots=True, plot_individuals=False, use_vboost_hack=True, linestyle=npvi_linestyle, color=npvi_color)
  #  vboostR4_plot = plot_mmd('/data/icml/learnToSample/data/ICML/frisk/vboost/run2/rank4', figureId=id,average_plots=True, plot_individuals=False,
  #           name_filter='', use_vboost_hack=True)
  #  vboostR3_plot = plot_mmd('/data/icml/learnToSample/data/ICML/frisk/vboost/run2/rank3', figureId=id,average_plots=True, plot_individuals=False,
  #           name_filter='', use_vboost_hack=True)
  #  vboostR2_plot = plot_mmd('/data/icml/learnToSample/data/ICML/frisk/vboost/run2/rank2', figureId=id,average_plots=True, plot_individuals=False,
  #           name_filter='', use_vboost_hack=True)
 #   vboostR1_plot = plot_mmd('/data/icml/learnToSample/data/ICML/frisk/vboost/run2/rank1', figureId=id,average_plots=True, plot_individuals=False,
 #            name_filter='', use_vboost_hack=True, linestyle=vboost1_linestyle, color=vboost1_color)
   # vboostR0_plot = plot_mmd('/data/icml/learnToSample/data/ICML/frisk/vboost/run2/rank0', figureId=id,average_plots=True, plot_individuals=False,
   #          name_filter='', use_vboost_hack=True, linestyle=vboost0_linestyle, color=vboost0_color)
    vboostR10_plot = plot_mmd('/data/icml/learnToSample/data/ICML/frisk/vboost/run2/rank10', figureId=id,average_plots=True, plot_individuals=False,
             name_filter='', use_vboost_hack=True, linestyle=vboost10_linestyle, color=vboost10_color)
  #  vboostR20_plot = plot_mmd('/data/icml/learnToSample/data/ICML/frisk/vboost/run2/rank20', figureId=id,average_plots=True, plot_individuals=False,
 #            name_filter='', use_vboost_hack=True)
   # vboostR5_plot = plot_mmd('/data/icml/learnToSample/data/ICML/frisk/vboost/run2/rank5', figureId=id,average_plots=True, plot_individuals=False,
  #           name_filter='', use_vboost_hack=True, linestyle=vboost5_linestyle, color=vboost5_color)
    leg = plt.legend([vipsS_plot[0], vips_plot[0], svgd_plot[0], hmc_plot[0], npvi_plot[0],
                  vboostR10_plot[0]],
               ['vips1', 'vips5', 'svgd', 'hmc','npvi',
                 'vboost10'])
    leg.draggable()
    plt.title("")

#    ess_plot = plot_mmd("/data/icml/learnToSample/data/ICML/breast_cancer/ess", figureId=id, average_plots=True, plot_individuals=False,
 #        name_filter='')
  #  plt.legend([more_plot[0], vips_plot[0], ess_plot[0]], ['more', 'vips', 'ess'])
   # plt.title('MMD (Frisk)')

if __name__ == "__main__":
    draw_breast_cancer_plot(1,True)
   # draw_10dplot(2, True)
   # draw_gmmplot(3, True)
   # draw_gmm_time_plot(4, False)
    draw_german_credit_plot(5,True)
   # draw_frisk_plot(6,True)
  #  draw_gmm40_plot(7,True)
  #  draw_iono_plot(8,True)

    #draw_breast_cancer_plot(7, False)
 #   draw_3dplot(1, True)
 #   draw_3dplot(2, False)
  #  draw_10dplot(4, False)
  #  draw_gmmplot(5, True)
  #  draw_gmmplot(6, False)
  #  draw_gmm_time_plot(7, False)
  #  draw_breast_cancer_plot(8,True)
  #  draw_breast_cancer_plot(9, False)

# plot_mmd("/data/icml/learnToSample/data/ICML/10link/svgd", figureId=2, average_plots=False, plot_individuals=False,
       #      name_filter='0.0005')[0]
   # plot_mmd("/data/icml/learnToSample/data/ICML/10link/vips/run2/explorative", figureId=2, average_plots=True,
     #        plot_individuals=False,name_filter='')

   # plot_mmd("/data/icml/learnToSample/data/ICML/10link/vips/run2", figureId=2, average_plots=True,
   #          plot_individuals=False, name_filter='')

    print("done")