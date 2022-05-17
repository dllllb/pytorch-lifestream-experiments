export SC_SUFFIX="subseq_smpl_SampleRandom"
export SC_STRATEGY="SampleRandom"
python -m ptls.pl_train_module \
    logger_name=${SC_SUFFIX} \
    data_module.train.split_strategy.split_strategy=$SC_STRATEGY \
    data_module.valid.split_strategy.split_strategy=$SC_STRATEGY \
    model_path="${hydra:runtime.cwd}/../../artifacts/scenario_gender/gender_mlm__$SC_SUFFIX.p" \
    --config-dir conf --config-name mles_params
python -m ptls.pl_inference \
    model_path="${hydra:runtime.cwd}/../../artifacts/scenario_gender/gender_mlm__$SC_SUFFIX.p" \
    output.path="${hydra:runtime.cwd}/data/emb__$SC_SUFFIX" \
    --config-dir conf --config-name mles_params


export SC_SUFFIX="subseq_smpl_SplitRandom"
export SC_STRATEGY="SplitRandom"
python -m ptls.pl_train_module \
    logger_name=${SC_SUFFIX} \
    data_module.train.split_strategy.cnt_max=300 \
    data_module.valid.split_strategy.cnt_max=300 \
    data_module.valid.batch_size=512 \
    data_module.train.split_strategy.split_strategy=$SC_STRATEGY \
    data_module.valid.split_strategy.split_strategy=$SC_STRATEGY \
    model_path="${hydra:runtime.cwd}/../../artifacts/scenario_gender/gender_mlm__$SC_SUFFIX.p" \
    --config-dir conf --config-name mles_params
python -m ptls.pl_inference \
    model_path="${hydra:runtime.cwd}/../../artifacts/scenario_gender/gender_mlm__$SC_SUFFIX.p" \
    output.path="${hydra:runtime.cwd}/data/emb__$SC_SUFFIX" \
    --config-dir conf --config-name mles_params


# Compare
rm results/scenario_gender__subseq_smpl_strategy.txt
# rm -r conf/embeddings_validation.work/
python -m embeddings_validation \
    --config-dir conf --config-name embeddings_validation_short --workers 10 --total_cpu_count 20 \
    --conf_extra \
      'report_file: "../results/scenario_gender__subseq_smpl_strategy.txt",
      auto_features: ["../data/emb__subseq_smpl_*.pickle"]'
