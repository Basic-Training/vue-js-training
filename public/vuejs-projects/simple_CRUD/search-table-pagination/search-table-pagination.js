new Vue({
    el: '#app',
    data: {
      formOptions: {
        inline: true,
        submitBtnText: 'Search',
        forms: [
          { prop: 'name', label: 'Name' },
          { prop: 'mobile', label: 'Mobile' },
          { prop: 'sex', label: 'Sex', itemType: 'select',
           options: [
             { value: '', label: 'All' },
             { value: 0, label: 'Male' },
             { value: 1, label: 'Female' }
           ]
          }
        ]
      },
      columns: [
        { prop: 'name', label: 'Name', width: 140 },
        { prop: 'mobile', label: 'Mobile', minWidth: 180 },
        { prop: 'sex', label: 'Sex', width: 100,
         render: row => {
           const { sex } = row
           return sex === 0 ? 'Male' : sex === 1 ? 'Female' : 'Unknow'
         }
        }
      ],
      tableData: [
        { name: 'Sam', mobile: '15299xxxx', sex: 0 },
        { name: 'Jean', mobile: '13452xxxx', sex: 1 },
        { name: 'Tony', mobile: '187233xxxx', sex: 0 }
      ]
    },
    template:`
      <el-search-table-pagination
        type="local"
        :data="tableData"
        :page-sizes="[5, 10]"
        :columns="columns"
        :form-options="formOptions">
      </el-search-table-pagination>
    `
  })