## c:/Users/ChandlerLutzDell/.emacs.d/scratch2.R

##    Chandler Lutz
##    Questions/comments: cl.eco@cbs.dk
##    $Revisions:      1.0.0     $Date:  2020-12-10

##Clear the workspace
##Delete all objects and detach packages
rm(list = ls()) 
suppressWarnings(CLmisc::detach_all_packages())

suppressPackageStartupMessages({library(CLmisc); })
