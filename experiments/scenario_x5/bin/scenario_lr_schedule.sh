# ReduceLROnPlateau
export SC_SUFFIX="lr_reduce_on_plateau"
python -m ptls.pl_train_module \
    logger_name=${SC_SUFFIX} \
    params.lr_scheduler.ReduceLROnPlateau=true \
    params.lr_scheduler.patience=3 \
    model_path="../../artifacts/scenario_x5/mles__$SC_SUFFIX.p" \
    --conf "conf/mles_params.hocon"
python -m ptls.pl_inference \
    model_path="../../artifacts/scenario_x5/mles__$SC_SUFFIX.p" \
    output.path="data/emb_mles__$SC_SUFFIX" \
    --conf "conf/mles_params.hocon"

# ReduceLROnPlateau x2 epochs
export SC_SUFFIX="lr_reduce_on_plateau_x2epochs"
python -m ptls.pl_train_module \
    logger_name=${SC_SUFFIX} \
    params.lr_scheduler.ReduceLROnPlateau=true \
    params.lr_scheduler.threshold=0.0001 \
    params.lr_scheduler.patience=3 \
    params.train.n_epoch=60 \
    model_path="../../artifacts/scenario_x5/mles__$SC_SUFFIX.p" \
    --conf "conf/mles_params.hocon"
python -m ptls.pl_inference \
    model_path="../../artifacts/scenario_x5/mles__$SC_SUFFIX.p" \
    output.path="data/emb_mles__$SC_SUFFIX" \
    --conf "conf/mles_params.hocon"

# CosineAnnealing
export SC_SUFFIX="lr_cosine_annealing"
python -m ptls.pl_train_module \
    logger_name=${SC_SUFFIX} \
    params.lr_scheduler.CosineAnnealing=true \
    params.train.lr_scheduler.n_epoch=30 \
    model_path="../../artifacts/scenario_x5/mles__$SC_SUFFIX.p" \
    --conf "conf/mles_params.hocon"
python -m ptls.pl_inference \
    model_path="../../artifacts/scenario_x5/mles__$SC_SUFFIX.p" \
    output.path="data/emb_mles__$SC_SUFFIX" \
    --conf "conf/mles_params.hocon"

# Compare
rm results/rm results/scenario_lr_schedule.txt
# rm -r conf/embeddings_validation.work/
python -m embeddings_validation \
    --conf conf/embeddings_validation_short.hocon --workers 10 --total_cpu_count 20 \
    --conf_extra \
      'report_file: "../results/scenario_lr_schedule.txt",
      auto_features: ["../data/emb_mles__lr_*.pickle"]'
